//
//  CategoryListView.swift
//  HadexGate
//

import SwiftUI

struct CategoryListView: View {
    let category: LoreCategory
    @Environment(SubscriptionManager.self) private var subscriptions

    private var entries: [LoreEntry] { LoreLibrary.entries(in: category) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                LazyVStack(spacing: 12) {
                    ForEach(entries) { entry in
                        NavigationLink(value: entry) {
                            LoreCard(entry: entry, isLocked: subscriptions.isLocked(entry))
                        }
                        .buttonStyle(.pressable)
                    }
                }
                Color.clear.frame(height: 96)
            }
            .padding(.horizontal, Metrics.screenPadding)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .hadexBackground()
        .navigationTitle(LocalizedStringKey(category.title))
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: LoreEntry.self) { LoreDetailView(entry: $0) }
    }

    private var header: some View {
        HStack(spacing: 14) {
            IconBadge(symbol: category.symbol, tint: category.tint, size: 54)
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(category.title))
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Palette.bone)
                Text(LocalizedStringKey(category.blurb))
                    .font(.subheadline)
                    .foregroundStyle(Palette.boneMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                .fill(Gradients.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                .stroke(category.tint.opacity(0.4), lineWidth: 1)
        )
    }
}
