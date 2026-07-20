//
//  SubscriptionManager.swift
//  HadexGate
//
//  StoreKit 2 manager for two one-time (non-consumable) unlocks. Handles
//  loading, purchasing, restoring, promoted-purchase intents and transaction
//  updates. Gracefully reports when the store is unavailable.
//

import StoreKit
import Observation

@MainActor
@Observable
final class SubscriptionManager {

    // Two one-time purchases (see Products.storekit).
    static let fullAccessID = "com.hadexgate.passage"
    static let oracleID = "com.hadexgate.oracle"
    static let productIDs = [fullAccessID, oracleID]

    enum Phase: Equatable {
        case idle
        case loading
        case purchasing(String)   // product id
        case failed(String)       // message
    }

    private(set) var products: [Product] = []
    private(set) var owned: Set<String> = []
    /// True when the store could not return the products (offline / not configured).
    private(set) var productsUnavailable = false
    var phase: Phase = .idle

    // Entitlements derived from ownership.
    var hasFullAccess: Bool { owned.contains(Self.fullAccessID) }
    var hasOracleUnlimited: Bool { owned.contains(Self.oracleID) }
    /// Kept for existing UI: "premium" = the full-access unlock.
    var isPremium: Bool { hasFullAccess }

    @ObservationIgnored private var intentsTask: Task<Void, Never>?
    @ObservationIgnored private var updatesTask: Task<Void, Never>?

    init() {
        intentsTask = observePurchaseIntents()
        updatesTask = observeTransactionUpdates()
        Task { await loadProducts() }
        Task { await refreshEntitlements() }
    }

    deinit {
        intentsTask?.cancel()
        updatesTask?.cancel()
    }

    // MARK: - Loading

    func loadProducts() async {
        phase = .loading
        // Retry a few times — the StoreKit test session (or the network) can be
        // briefly not ready, which is what makes products appear "every other time".
        for attempt in 0..<5 {
            do {
                let loaded = try await Product.products(for: Self.productIDs)
                let ordered = Self.productIDs.compactMap { id in loaded.first { $0.id == id } }
                if !ordered.isEmpty {
                    products = ordered
                    productsUnavailable = false
                    phase = .idle
                    return
                }
            } catch {
                // fall through and retry
            }
            if attempt < 4 {
                try? await Task.sleep(for: .milliseconds(700))
            }
        }
        // Every attempt returned nothing: keep any products we already had.
        if products.isEmpty { productsUnavailable = true }
        phase = .idle
    }

    // MARK: - Purchase

    @discardableResult
    func buyProduct(_ product: Product) async -> Bool {
        phase = .purchasing(product.id)
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await refreshEntitlements()
                phase = .idle
                Haptics.success()
                return true
            case .userCancelled:
                phase = .idle
                return false
            case .pending:
                phase = .idle
                return false
            @unknown default:
                phase = .idle
                return false
            }
        } catch {
            phase = .failed("The purchase could not be completed.")
            Haptics.warning()
            return false
        }
    }

    @discardableResult
    func buyProduct(id: String) async -> Bool {
        guard let product = products.first(where: { $0.id == id }) else { return false }
        return await buyProduct(product)
    }

    func restore() async {
        phase = .loading
        try? await AppStore.sync()
        await refreshEntitlements()
        phase = .idle
        if owned.isEmpty {
            phase = .failed("No previous purchases were found.")
        } else {
            Haptics.success()
        }
    }

    // MARK: - Entitlements

    func refreshEntitlements() async {
        var active: Set<String> = []
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result), transaction.revocationDate == nil {
                active.insert(transaction.productID)
            }
        }
        owned = active
    }

    func isOwned(_ id: String) -> Bool { owned.contains(id) }

    /// Whether a lore entry is locked behind the full-access purchase.
    /// The torments of Tartarus are the premium content in this build.
    func isLocked(_ entry: LoreEntry) -> Bool {
        !hasFullAccess && entry.category == .punishment
    }

    // MARK: - StoreKit contract

    private func observePurchaseIntents() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            for await intent in PurchaseIntent.intents {
                await self?.buyProduct(intent.product)
            }
        }
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            for await update in Transaction.updates {
                guard let self else { continue }
                if let transaction = try? self.checkVerified(update) {
                    await transaction.finish()
                    await self.refreshEntitlements()
                }
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error): throw error
        case .verified(let safe): return safe
        }
    }

    // MARK: - Display helpers

    func product(for id: String) -> Product? {
        products.first { $0.id == id }
    }

    func displayPrice(for id: String, fallback: String) -> String {
        products.first { $0.id == id }?.displayPrice ?? fallback
    }
}
