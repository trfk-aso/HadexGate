//
//  CollectionDetailView.swift
//  HadexGate
//

import SwiftUI

struct CollectionDetailView: View {
    let collection: LoreCollection
    @Environment(SubscriptionManager.self) private var subscriptions

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                banner

                ForEach(Array(collection.entries.enumerated()), id: \.element.id) { index, entry in
                    NavigationLink(value: entry) {
                        HStack(spacing: 14) {
                            Text("\(index + 1)")
                                .font(.system(.title3, design: .serif).weight(.bold))
                                .foregroundStyle(collection.tint.key)
                                .frame(width: 30)
                            LoreCard(entry: entry, isLocked: subscriptions.isLocked(entry))
                        }
                    }
                    .buttonStyle(.pressable)
                }
                Color.clear.frame(height: 96)
            }
            .padding(.horizontal, Metrics.screenPadding)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .hadexBackground()
        .navigationTitle(LocalizedStringKey(collection.title))
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: LoreEntry.self) { LoreDetailView(entry: $0) }
    }

    private var banner: some View {
        ZStack(alignment: .bottomLeading) {
            ArtworkView(style: ArtworkStyle(symbol: collection.symbol, tint: collection.tint, seed: collection.id.hashValue), symbolScale: 0.32)
                .frame(height: 180)
            LinearGradient(colors: [.clear, Palette.abyss.opacity(0.85)], startPoint: .center, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 6) {
                TagPill(text: "\(collection.entries.count) parts", systemImage: collection.symbol, tint: collection.tint.key)
                Text(LocalizedStringKey(collection.title))
                    .font(.system(.title2, design: .serif).weight(.bold))
                    .foregroundStyle(Palette.bone)
                Text(LocalizedStringKey(collection.subtitle))
                    .font(.subheadline)
                    .foregroundStyle(Palette.boneMuted)
            }
            .padding(16)
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                .stroke(collection.tint.key.opacity(0.4), lineWidth: 1)
        )
    }
}
