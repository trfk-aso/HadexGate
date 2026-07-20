//
//  LoreDetailView.swift
//  HadexGate
//
//  The detail / result screen for any lore entry. Shows artwork, quick-fact
//  parameters, narrative sections, related entries, and Save / Share actions.
//

import SwiftUI

struct LoreDetailView: View {
    let entry: LoreEntry

    @Environment(LibraryStore.self) private var library
    @Environment(SubscriptionManager.self) private var subscriptions
    @Environment(PaywallPresenter.self) private var paywall
    @Environment(\.dismiss) private var dismiss
    @State private var appeared = false

    private var locked: Bool { subscriptions.isLocked(entry) }

    private var related: [LoreEntry] {
        LoreLibrary.entries(in: entry.category).filter { $0.id != entry.id }.prefix(6).map { $0 }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                header

                if locked {
                    lockedCard
                } else {
                    factGrid

                    ForEach(entry.sections) { section in
                        sectionBlock(section)
                    }

                    tagCloud

                    if !related.isEmpty {
                        relatedBlock
                    }
                }

                Color.clear.frame(height: 90)
            }
            .padding(.horizontal, Metrics.screenPadding)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .hadexBackground()
        .navigationTitle(LocalizedStringKey(entry.name))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                shareButton
            }
        }
        .onAppear {
            library.recordView(entry)
            withAnimation(.easeOut(duration: 0.5)) { appeared = true }
        }
    }

    // MARK: - Locked state

    private var lockedCard: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle().fill(Gradients.glow(Palette.gold)).frame(width: 120, height: 120)
                Image(systemName: "lock.fill")
                    .font(.system(size: 44, weight: .light))
                    .foregroundStyle(Gradients.gold)
            }
            Text("This torment is sealed")
                .font(.title3.weight(.bold))
                .foregroundStyle(Palette.bone)
            Text("Unlock the complete bestiary and every torment of Tartarus with the Hadex Passage — a one-time purchase.")
                .font(.subheadline)
                .foregroundStyle(Palette.boneMuted)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            Button {
                Haptics.tap(.medium)
                paywall.present()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "crown.fill")
                    Text("Unlock · \(subscriptions.displayPrice(for: SubscriptionManager.fullAccessID, fallback: "$1.99"))")
                }
            }
            .buttonStyle(.ember)
            .padding(.horizontal, 24)
            .padding(.top, 4)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous).fill(Palette.charcoal.opacity(0.6)))
        .overlay(RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous).stroke(Palette.gold.opacity(0.4), lineWidth: 1))
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 16) {
            ArtworkView(style: entry.artwork, symbolScale: 0.34)
                .frame(height: 230)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(entry.category.tint.opacity(0.5), lineWidth: 1)
                )
                .shadow(color: entry.category.tint.opacity(0.4), radius: 26, y: 12)
                .scaleEffect(appeared ? 1 : 0.94)

            VStack(spacing: 8) {
                Text(LocalizedStringKey(entry.epithet)).textCase(.uppercase)
                    .font(.caption.weight(.bold))
                    .tracking(2)
                    .foregroundStyle(entry.category.tint)
                    .multilineTextAlignment(.center)

                Text(LocalizedStringKey(entry.summary))
                    .font(.body)
                    .foregroundStyle(Palette.boneMuted)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            saveButton
        }
    }

    private var saveButton: some View {
        Button {
            library.toggleFavorite(entry)
        } label: {
            let saved = library.isFavorite(entry.id)
            HStack(spacing: 8) {
                Image(systemName: saved ? "bookmark.fill" : "bookmark")
                Text(saved ? "Saved to Library" : "Save to Library")
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(saved ? Palette.abyss : Palette.bone)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(saved ? AnyShapeStyle(Gradients.gold) : AnyShapeStyle(Palette.slate))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Palette.gold.opacity(0.4), lineWidth: 1)
            )
        }
        .buttonStyle(.pressable)
    }

    private var shareButton: some View {
        ShareLink(item: shareText) {
            Image(systemName: "square.and.arrow.up")
                .foregroundStyle(Palette.ember)
        }
    }

    private var shareText: String {
        "\(entry.name) — \(entry.epithet)\n\n\(entry.summary)\n\nFrom Hadex Gate: the Greek Underworld."
    }

    // MARK: - Facts

    private var factGrid: some View {
        SurfaceCard(tint: entry.category.tint) {
            VStack(spacing: 6) {
                HStack {
                    Text("Quick Facts")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Palette.bone)
                    Spacer()
                    Image(systemName: entry.category.symbol)
                        .foregroundStyle(entry.category.tint)
                }
                .padding(.bottom, 4)
                ForEach(entry.facts) { fact in
                    ParameterRow(icon: fact.icon, label: fact.label, value: fact.value,
                                 tint: entry.category.tint)
                    if fact.id != entry.facts.last?.id {
                        Divider().overlay(Palette.ash)
                    }
                }
            }
        }
    }

    private func sectionBlock(_ section: LoreSection) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Rectangle()
                    .fill(Gradients.ember)
                    .frame(width: 3, height: 18)
                    .clipShape(Capsule())
                Text(LocalizedStringKey(section.title))
                    .font(.headline)
                    .foregroundStyle(Palette.bone)
            }
            Text(LocalizedStringKey(section.body))
                .font(.callout)
                .foregroundStyle(Palette.boneMuted)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                .fill(Palette.charcoal.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                .stroke(Palette.ash, lineWidth: 1)
        )
    }

    private var tagCloud: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Themes", systemImage: "tag.fill")
            FlexibleTags(tags: entry.tags, tint: entry.category.tint)
        }
    }

    private var relatedBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "More \(entry.category.title)", systemImage: entry.category.symbol)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(related) { item in
                        NavigationLink(value: item) {
                            LoreTile(entry: item, isLocked: subscriptions.isLocked(item))
                        }
                        .buttonStyle(.pressable)
                    }
                }
                .padding(.bottom, 4)
            }
        }
    }
}

/// A simple wrapping tag layout.
private struct FlexibleTags: View {
    let tags: [String]
    let tint: Color

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(tags, id: \.self) { tag in
                TagPill(text: tag, tint: tint)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoreDetailView(entry: LoreLibrary.all[2])
    }
    .environment(LibraryStore())
    .environment(SubscriptionManager())
}
