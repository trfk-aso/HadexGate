//
//  LoreCards.swift
//  HadexGate
//
//  Reusable cards for presenting lore entries and collections.
//

import SwiftUI

// MARK: - Full-width list card

struct LoreCard: View {
    let entry: LoreEntry
    var isFavorite: Bool = false
    var isLocked: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            ArtworkView(style: entry.artwork)
                .frame(width: 76, height: 76)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(alignment: .topLeading) {
                    if isLocked { LockChip() }
                }

            VStack(alignment: .leading, spacing: 5) {
                Text(LocalizedStringKey(entry.name))
                    .font(.headline)
                    .foregroundStyle(Palette.bone)
                    .lineLimit(1)
                Text(LocalizedStringKey(entry.epithet))
                    .font(.caption)
                    .foregroundStyle(Palette.boneMuted)
                    .lineLimit(2)
                TagPill(text: entry.category.singular, systemImage: entry.category.symbol,
                        tint: entry.category.tint)
            }
            Spacer(minLength: 0)

            VStack {
                if isFavorite {
                    Image(systemName: "bookmark.fill")
                        .font(.caption)
                        .foregroundStyle(Palette.gold)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Palette.smoke)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                .fill(Gradients.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                .stroke(entry.category.tint.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Compact tile for horizontal scrolls

struct LoreTile: View {
    let entry: LoreEntry
    var isLocked: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ArtworkView(style: entry.artwork)
                .frame(width: 158, height: 118)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: Metrics.tileRadius, topTrailingRadius: Metrics.tileRadius, style: .continuous))
                .overlay(alignment: .topLeading) {
                    if isLocked { LockChip() }
                }

            VStack(alignment: .leading, spacing: 3) {
                Text(LocalizedStringKey(entry.name))
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Palette.bone)
                    .lineLimit(1)
                Text(LocalizedStringKey(entry.epithet))
                    .font(.caption2)
                    .foregroundStyle(Palette.boneMuted)
                    .lineLimit(2)
                    .frame(height: 30, alignment: .top)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 158)
        .background(
            RoundedRectangle(cornerRadius: Metrics.tileRadius, style: .continuous)
                .fill(Gradients.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.tileRadius, style: .continuous)
                .stroke(entry.category.tint.opacity(0.28), lineWidth: 1)
        )
    }
}

// MARK: - Large feature banner

struct FeatureBanner: View {
    let entry: LoreEntry

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ArtworkView(style: entry.artwork, symbolScale: 0.36)
                .frame(height: 210)

            LinearGradient(
                colors: [.clear, Palette.abyss.opacity(0.85)],
                startPoint: .center, endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 8) {
                TagPill(text: "Featured", systemImage: "star.fill", tint: Palette.gold)
                Text(LocalizedStringKey(entry.name))
                    .font(.system(.title, design: .serif).weight(.bold))
                    .foregroundStyle(Palette.bone)
                Text(LocalizedStringKey(entry.hook.isEmpty ? entry.epithet : entry.hook))
                    .font(.subheadline)
                    .foregroundStyle(Palette.boneMuted)
                    .lineLimit(2)
            }
            .padding(18)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 210)
        .clipShape(RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                .stroke(Palette.gold.opacity(0.35), lineWidth: 1)
        )
        .shadow(color: entry.category.tint.opacity(0.35), radius: 22, y: 10)
    }
}

// MARK: - Category chip

struct CategoryChip: View {
    let category: LoreCategory
    var count: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            IconBadge(symbol: category.symbol, tint: category.tint, size: 44)
            Spacer(minLength: 0)
            Text(LocalizedStringKey(category.title))
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Palette.bone)
                .lineLimit(1)
            Text("\(count) entries")
                .font(.caption2)
                .foregroundStyle(Palette.boneMuted)
        }
        .padding(14)
        .frame(width: 140, height: 150, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Metrics.tileRadius, style: .continuous)
                .fill(Gradients.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.tileRadius, style: .continuous)
                .stroke(category.tint.opacity(0.35), lineWidth: 1)
        )
    }
}

// MARK: - Collection card

struct CollectionCard: View {
    let collection: LoreCollection

    var body: some View {
        HStack(spacing: 14) {
            ArtworkView(style: ArtworkStyle(symbol: collection.symbol, tint: collection.tint, seed: collection.id.hashValue))
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(collection.title))
                    .font(.headline)
                    .foregroundStyle(Palette.bone)
                Text(LocalizedStringKey(collection.subtitle))
                    .font(.caption)
                    .foregroundStyle(Palette.boneMuted)
                    .lineLimit(2)
                Text("\(collection.entries.count) parts")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(collection.tint.key)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(Palette.smoke)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                .fill(Gradients.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                .stroke(collection.tint.key.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Lock chip (premium content marker)

struct LockChip: View {
    var body: some View {
        Image(systemName: "lock.fill")
            .font(.caption2.weight(.bold))
            .foregroundStyle(Palette.abyss)
            .padding(6)
            .background(Circle().fill(Gradients.gold))
            .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 1))
            .padding(6)
    }
}
