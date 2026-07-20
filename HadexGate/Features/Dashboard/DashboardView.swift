//
//  DashboardView.swift
//  HadexGate
//
//  The main screen. Combines several distinct content-block types (feature
//  banner, category scroll, action grid, featured tiles, collections list,
//  recent activity) and routes to every module.
//

import SwiftUI
import StoreKit

struct DashboardView: View {
    @Binding var selection: AppTab

    @Environment(SubscriptionManager.self) private var subscriptions
    @Environment(LibraryStore.self) private var library
    @Environment(ReviewManager.self) private var review
    @Environment(PaywallPresenter.self) private var paywall
    @Environment(\.requestReview) private var requestReview

    @State private var appeared = false

    private let featured = LoreLibrary.entry(id: "cerberus")!
    private let featuredMonsters = LoreLibrary.entries(in: .monster)
    private let collections = CollectionsLibrary.all

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    greeting

                    NavigationLink(value: featured) {
                        FeatureBanner(entry: featured)
                    }
                    .buttonStyle(.pressable)

                    categoryScroll

                    trialsGrid

                    oracleCard

                    featuredMonstersBlock

                    collectionsBlock

                    if !library.recentEvents.isEmpty {
                        recentBlock
                    }

                    if !subscriptions.isPremium {
                        premiumCard
                    }

                    Color.clear.frame(height: 96)
                }
                .padding(.horizontal, Metrics.screenPadding)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .hadexBackground()
            .navigationDestination(for: LoreEntry.self) { LoreDetailView(entry: $0) }
            .navigationDestination(for: LoreCollection.self) { CollectionDetailView(collection: $0) }
            .navigationDestination(for: LoreCategory.self) { CategoryListView(category: $0) }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("HADEX GATE")
                        .font(.system(.headline, design: .serif).weight(.heavy))
                        .tracking(3)
                        .foregroundStyle(Gradients.gold)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Haptics.tap()
                        paywall.present()
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: subscriptions.isPremium ? "crown.fill" : "flame.fill")
                            Text(LocalizedStringKey(subscriptions.isPremium ? "Passage" : "Unlock"))
                        }
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Palette.abyss)
                        .padding(.horizontal, 11).padding(.vertical, 6)
                        .background(Capsule().fill(Gradients.gold))
                    }
                    .buttonStyle(.plain)
                }
            }
            .task {
                // Ask for an App Store rating on the second launch, once — shown
                // on the main screen after the app restarts (post-splash).
                guard review.shouldRequestReview else { return }
                try? await Task.sleep(for: .seconds(1.5))
                review.markReviewRequested()
                requestReview()
            }
        }
    }

    // MARK: - Blocks

    private var greeting: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Welcome, seeker")
                .font(.title2.weight(.bold))
                .foregroundStyle(Palette.bone)
            Text("The gate stands open before you.")
                .font(.subheadline)
                .foregroundStyle(Palette.boneMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var categoryScroll: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Realms of Knowledge", subtitle: "Explore the underworld by theme", systemImage: "square.grid.2x2.fill")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(LoreCategory.allCases) { category in
                        NavigationLink(value: category) {
                            CategoryChip(category: category, count: LoreLibrary.entries(in: category).count)
                        }
                        .buttonStyle(.pressable)
                    }
                }
            }
        }
    }

    private var trialsGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Trials of the Gate", systemImage: "die.face.5.fill")
            HStack(spacing: 12) {
                actionCard(
                    title: "Gate Test",
                    subtitle: "Where would your soul go?",
                    symbol: "door.left.hand.open",
                    gradient: Gradients.gold
                ) { selection = .trials }

                actionCard(
                    title: "Dark Quiz",
                    subtitle: "Test your myth knowledge",
                    symbol: "checkmark.seal.fill",
                    gradient: Gradients.blood
                ) { selection = .trials }
            }
        }
    }

    private func actionCard(title: String, subtitle: String, symbol: String,
                            gradient: LinearGradient, action: @escaping () -> Void) -> some View {
        Button {
            Haptics.tap(.medium)
            action()
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                IconBadge(symbol: symbol, tint: .white.opacity(0.001), size: 42)
                    .overlay(
                        Image(systemName: symbol)
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundStyle(.white)
                    )
                Spacer(minLength: 8)
                Text(LocalizedStringKey(title))
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(LocalizedStringKey(subtitle))
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, minHeight: 148, alignment: .leading)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                    .fill(gradient)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                    .stroke(.white.opacity(0.15), lineWidth: 1)
            )
        }
        .buttonStyle(.pressable)
    }

    private var oracleCard: some View {
        Button {
            Haptics.tap(.medium)
            selection = .oracle
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(Gradients.spirit).frame(width: 56, height: 56)
                    Image(systemName: "sparkles")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("Ask the Keeper of the Gate")
                        .font(.headline)
                        .foregroundStyle(Palette.bone)
                    Text("Your AI guide to every myth and monster")
                        .font(.caption)
                        .foregroundStyle(Palette.boneMuted)
                        .lineLimit(2)
                }
                Spacer(minLength: 0)
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Palette.violet)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                    .fill(Gradients.card)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                    .stroke(Palette.violet.opacity(0.45), lineWidth: 1)
            )
        }
        .buttonStyle(.pressable)
    }

    private var featuredMonstersBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SectionHeader(title: "The Bestiary", systemImage: "pawprint.fill")
                Spacer()
                NavigationLink(value: LoreCategory.monster) {
                    Text("See all")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Palette.ember)
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(featuredMonsters) { monster in
                        NavigationLink(value: monster) {
                            LoreTile(entry: monster)
                        }
                        .buttonStyle(.pressable)
                    }
                }
            }
        }
    }

    private var collectionsBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Curated Descents", subtitle: "Guided journeys through the dark", systemImage: "rectangle.stack.fill")
            VStack(spacing: 12) {
                ForEach(collections.prefix(3)) { collection in
                    NavigationLink(value: collection) {
                        CollectionCard(collection: collection)
                    }
                    .buttonStyle(.pressable)
                }
            }
        }
    }

    private var recentBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Your Recent Path", systemImage: "clock.arrow.circlepath")
            VStack(spacing: 10) {
                ForEach(library.recentEvents.prefix(4)) { event in
                    HistoryRow(event: event)
                }
            }
        }
    }

    private var premiumCard: some View {
        Button {
            Haptics.tap(.medium)
            paywall.present()
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "crown.fill").foregroundStyle(Palette.gold)
                    Text("Hadex Passage")
                        .font(.headline).foregroundStyle(Palette.bone)
                    Spacer()
                }
                Text("Unlock the full bestiary, unlimited Oracle wisdom, and every torment of Tartarus.")
                    .font(.subheadline)
                    .foregroundStyle(Palette.boneMuted)
                    .fixedSize(horizontal: false, vertical: true)
                Text("View Passage")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Palette.abyss)
                    .padding(.horizontal, 18).padding(.vertical, 10)
                    .background(Capsule().fill(Gradients.ember))
                    .padding(.top, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                    .fill(Gradients.spirit)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                    .stroke(Palette.gold.opacity(0.4), lineWidth: 1)
            )
        }
        .buttonStyle(.pressable)
    }
}

#Preview {
    MainTabView()
        .environment(SubscriptionManager())
        .environment(LibraryStore())
        .environment(OracleService())
}
