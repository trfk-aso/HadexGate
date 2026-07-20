//
//  PaywallView.swift
//  HadexGate
//
//  Two one-time (non-consumable) unlocks at $1.99 each, with a prominent Restore
//  button. StoreKit 2. If the store is unavailable the products still show, with
//  a clear "currently unavailable" note and disabled buy buttons.
//

import SwiftUI
import StoreKit

private struct UnlockItem {
    let id: String
    let icon: String
    let title: String
    let subtitle: String
    let tint: Color
    let fallbackPrice: String
}

struct PaywallView: View {
    @Environment(SubscriptionManager.self) private var subscriptions
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var glow = false

    private var items: [UnlockItem] {
        [
            UnlockItem(id: SubscriptionManager.fullAccessID, icon: "crown.fill",
                       title: "Hadex Passage", subtitle: "Full access — the complete bestiary and every torment of Tartarus.",
                       tint: Palette.gold, fallbackPrice: "$1.99"),
            UnlockItem(id: SubscriptionManager.oracleID, icon: "sparkles",
                       title: "Keeper's Oracle", subtitle: "Ask the Keeper of the Gate without limit.",
                       tint: Palette.violet, fallbackPrice: "$1.99"),
        ]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                mediaBlock

                VStack(spacing: 8) {
                    Text("Unlock Hadex Gate")
                        .font(.system(.title, design: .serif).weight(.heavy))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Palette.bone)
                    Text("One-time purchases. Yours forever, no subscription.")
                        .font(.subheadline)
                        .foregroundStyle(Palette.boneMuted)
                        .multilineTextAlignment(.center)
                }

                if subscriptions.productsUnavailable {
                    unavailableNote
                }

                VStack(spacing: 14) {
                    ForEach(items, id: \.id) { item in
                        productCard(item)
                    }
                }

                restoreButton

                footer

                Color.clear.frame(height: 20)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Metrics.screenPadding)
        }
        .scrollIndicators(.hidden)
        .hadexBackground(emberCount: 30)
        .overlay(alignment: .top) { closeButton }
        .task {
            // Always re-attempt when the paywall opens (with internal retries),
            // so a transient miss doesn't leave it stuck on "unavailable".
            await subscriptions.loadProducts()
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) { glow = true }
        }
    }

    // MARK: - Media block

    private var mediaBlock: some View {
        ZStack {
            Gradients.spirit
            ArtworkView(style: ArtworkStyle(symbol: "flame.fill", tint: .ember, seed: 4242), symbolScale: 0.34)
                .opacity(0.9)
            RadialGradient(colors: [.clear, Palette.abyss.opacity(0.7)], center: .center, startRadius: 40, endRadius: 260)
            VStack {
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                    Text("HADEX GATE")
                        .font(.caption.weight(.heavy)).tracking(3)
                }
                .foregroundStyle(Palette.abyss)
                .padding(.horizontal, 16).padding(.vertical, 8)
                .background(Capsule().fill(Gradients.gold))
                .shadow(color: Palette.gold.opacity(glow ? 0.7 : 0.3), radius: glow ? 20 : 8)
                .padding(.bottom, 18)
            }
        }
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 28, style: .continuous).stroke(Palette.gold.opacity(0.4), lineWidth: 1))
        .padding(.top, 56)
        .shadow(color: Palette.violet.opacity(0.5), radius: 30, y: 14)
    }

    private var unavailableNote: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(Palette.gold)
                Text("In-app purchases are currently unavailable. You can still see what's inside — please try again later.")
                    .font(.caption)
                    .foregroundStyle(Palette.boneMuted)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
            Button {
                Haptics.tap()
                Task { await subscriptions.loadProducts() }
            } label: {
                HStack(spacing: 6) {
                    if case .loading = subscriptions.phase {
                        ProgressView().tint(Palette.gold)
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                    Text("Retry")
                }
                .font(.caption.weight(.bold))
                .foregroundStyle(Palette.gold)
                .padding(.horizontal, 14).padding(.vertical, 7)
                .background(Capsule().fill(Palette.gold.opacity(0.15)))
                .overlay(Capsule().stroke(Palette.gold.opacity(0.4), lineWidth: 1))
            }
            .buttonStyle(.pressable)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Palette.gold.opacity(0.10)))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Palette.gold.opacity(0.35), lineWidth: 1))
    }

    // MARK: - Product card

    private func productCard(_ item: UnlockItem) -> some View {
        let owned = subscriptions.isOwned(item.id)
        let price = subscriptions.displayPrice(for: item.id, fallback: item.fallbackPrice)
        let purchasing = isPurchasing(item.id)

        return VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                Image(systemName: item.icon)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(LinearGradient(colors: [item.tint, item.tint.opacity(0.55)],
                                             startPoint: .topLeading, endPoint: .bottomTrailing)))
                VStack(alignment: .leading, spacing: 3) {
                    Text(item.title).font(.headline).foregroundStyle(Palette.bone)
                    Text(item.subtitle)
                        .font(.caption).foregroundStyle(Palette.boneMuted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }

            buyButton(item: item, owned: owned, price: price, purchasing: purchasing)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous).fill(Gradients.card))
        .overlay(RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
            .stroke(owned ? Palette.styx.opacity(0.6) : item.tint.opacity(0.4), lineWidth: 1))
    }

    @ViewBuilder
    private func buyButton(item: UnlockItem, owned: Bool, price: String, purchasing: Bool) -> some View {
        if owned {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill")
                Text("Unlocked")
            }
            .font(.subheadline.weight(.bold))
            .foregroundStyle(Palette.styx)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Palette.styx.opacity(0.15)))
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Palette.styx.opacity(0.5), lineWidth: 1))
        } else {
            Button {
                Task { await subscriptions.buyProduct(id: item.id) }
            } label: {
                HStack(spacing: 8) {
                    if purchasing {
                        ProgressView().tint(Palette.abyss)
                    } else if subscriptions.productsUnavailable {
                        Image(systemName: "lock.fill")
                        Text("Unavailable")
                    } else {
                        Text("Unlock")
                        Text("· \(price)").fontWeight(.heavy)
                    }
                }
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Palette.abyss)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(subscriptions.productsUnavailable ? AnyShapeStyle(Palette.smoke) : AnyShapeStyle(
                        LinearGradient(colors: [item.tint, item.tint.opacity(0.7)],
                                       startPoint: .leading, endPoint: .trailing))))
            }
            .buttonStyle(.pressable)
            .disabled(subscriptions.productsUnavailable || purchasing)
        }
    }

    // MARK: - Restore (prominent)

    private var restoreButton: some View {
        Button {
            Task { await subscriptions.restore() }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "arrow.clockwise")
                Text("Restore Purchases")
            }
        }
        .buttonStyle(.ember)
    }

    private var footer: some View {
        VStack(spacing: 10) {
            if case .failed(let message) = subscriptions.phase {
                Text(message)
                    .font(.caption).foregroundStyle(Palette.gold)
                    .multilineTextAlignment(.center)
            }
            Text("These are one-time purchases charged to your Apple ID. Already bought them? Use Restore Purchases to unlock again on this account.")
                .font(.caption2)
                .foregroundStyle(Palette.smoke)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 2)
    }

    private var closeButton: some View {
        HStack {
            Spacer()
            Button {
                Haptics.tap()
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Palette.bone)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(.ultraThinMaterial).environment(\.colorScheme, .dark))
            }
        }
        .padding(.horizontal, Metrics.screenPadding)
        .padding(.top, 12)
    }

    private func isPurchasing(_ id: String) -> Bool {
        if case .purchasing(let pid) = subscriptions.phase { return pid == id }
        return false
    }
}

#Preview {
    PaywallView()
        .environment(SubscriptionManager())
}
