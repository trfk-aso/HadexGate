//
//  ExploreView.swift
//  HadexGate
//
//  A searchable library of every lore entry, filterable by category.
//

import SwiftUI

struct ExploreView: View {
    @Environment(SubscriptionManager.self) private var subscriptions
    @State private var query = ""
    @State private var filter: LoreCategory? = nil
    @FocusState private var searchFocused: Bool

    private var results: [LoreEntry] {
        var items = LoreLibrary.all
        if let filter { items = items.filter { $0.category == filter } }
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        if !q.isEmpty { items = items.filter { $0.searchText.contains(q) } }
        return items
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    searchField

                    filterRow

                    if results.isEmpty {
                        EmptyStateView(
                            symbol: "magnifyingglass",
                            title: "No shades found",
                            message: "No lore matches your search. Try another name — Cerberus, Styx, Orpheus — or clear your filters.",
                            actionTitle: "Clear Search"
                        ) {
                            query = ""
                            filter = nil
                            searchFocused = false
                        }
                        .padding(.top, 40)
                    } else {
                        Text("\(results.count) \(results.count == 1 ? "entry" : "entries")")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Palette.smoke)
                        LazyVStack(spacing: 12) {
                            ForEach(results) { entry in
                                NavigationLink(value: entry) {
                                    LoreCard(entry: entry, isLocked: subscriptions.isLocked(entry))
                                }
                                .buttonStyle(.pressable)
                            }
                        }
                    }
                    Color.clear.frame(height: 96)
                }
                .padding(.horizontal, Metrics.screenPadding)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .hadexBackground()
            .navigationDestination(for: LoreEntry.self) { LoreDetailView(entry: $0) }
            .navigationDestination(for: LoreCategory.self) { CategoryListView(category: $0) }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Explore the Dark")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Palette.bone)
                }
            }
            // Dismiss via swipe (scrollDismissesKeyboard); a screen-wide tap
            // gesture would steal the tap that focuses the search field.
        }
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Palette.smoke)
            TextField("", text: $query, prompt: Text("Search monsters, rivers, heroes…").foregroundColor(Palette.smoke))
                .focused($searchFocused)
                .foregroundStyle(Palette.bone)
                .submitLabel(.search)
            if !query.isEmpty {
                Button {
                    query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Palette.smoke)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Palette.charcoal)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(searchFocused ? Palette.ember.opacity(0.6) : Palette.ash, lineWidth: 1)
        )
    }

    private var filterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterPill(title: "All", symbol: "circle.grid.3x3.fill", isOn: filter == nil) {
                    filter = nil
                }
                ForEach(LoreCategory.allCases) { category in
                    filterPill(title: category.title, symbol: category.symbol,
                               tint: category.tint, isOn: filter == category) {
                        filter = filter == category ? nil : category
                    }
                }
            }
        }
    }

    private func filterPill(title: String, symbol: String, tint: Color = Palette.ember,
                            isOn: Bool, action: @escaping () -> Void) -> some View {
        Button {
            Haptics.selection()
            withAnimation(.easeInOut(duration: 0.2)) { action() }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: symbol).font(.caption2.weight(.bold))
                Text(title).font(.caption.weight(.semibold))
            }
            .foregroundStyle(isOn ? Palette.abyss : Palette.boneMuted)
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(
                Capsule().fill(isOn ? AnyShapeStyle(tint) : AnyShapeStyle(Palette.charcoal))
            )
            .overlay(
                Capsule().stroke(tint.opacity(isOn ? 0 : 0.35), lineWidth: 1)
            )
        }
        .buttonStyle(.pressable)
    }
}

#Preview {
    ExploreView()
        .environment(LibraryStore())
        .environment(SubscriptionManager())
}
