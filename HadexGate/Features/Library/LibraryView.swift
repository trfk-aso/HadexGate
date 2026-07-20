//
//  LibraryView.swift
//  HadexGate
//
//  The "Library" tab — the user's saved lore and their action history, plus
//  access to settings. Two distinct feature modules behind one hub.
//

import SwiftUI

struct LibraryView: View {
    @Environment(LibraryStore.self) private var library

    enum Segment: String, CaseIterable { case saved = "Saved", history = "History" }
    @State private var segment: Segment = .saved
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    profileHeader

                    picker

                    switch segment {
                    case .saved: savedSection
                    case .history: historySection
                    }

                    Color.clear.frame(height: 96)
                }
                .padding(.horizontal, Metrics.screenPadding)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .hadexBackground()
            .navigationDestination(for: LoreEntry.self) { LoreDetailView(entry: $0) }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Your Library")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Palette.bone)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Haptics.tap()
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill").foregroundStyle(Palette.ember)
                    }
                }
            }
            .sheet(isPresented: $showSettings) { SettingsView() }
        }
    }

    private var profileHeader: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().fill(Gradients.spirit).frame(width: 66, height: 66)
                Image(systemName: "person.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Seeker of the Gate")
                    .font(.headline)
                    .foregroundStyle(Palette.bone)
                HStack(spacing: 14) {
                    stat(value: "\(library.favoriteIDs.count)", label: "Saved")
                    stat(value: "\(library.history.filter { $0.kind == .viewed }.count)", label: "Explored")
                    stat(value: "\(library.history.filter { $0.kind == .quiz }.count)", label: "Quizzes")
                }
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous).fill(Gradients.card))
        .overlay(RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous).stroke(Palette.violet.opacity(0.4), lineWidth: 1))
    }

    private func stat(value: String, label: String) -> some View {
        VStack(spacing: 1) {
            Text(value).font(.title3.weight(.bold)).foregroundStyle(Palette.ember)
            Text(label).font(.caption2).foregroundStyle(Palette.boneMuted)
        }
    }

    private var picker: some View {
        HStack(spacing: 6) {
            ForEach(Segment.allCases, id: \.self) { seg in
                Button {
                    Haptics.selection()
                    withAnimation(.easeInOut(duration: 0.2)) { segment = seg }
                } label: {
                    Text(seg.rawValue)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(segment == seg ? Palette.abyss : Palette.boneMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(segment == seg ? AnyShapeStyle(Gradients.ember) : AnyShapeStyle(Color.clear))
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(Palette.charcoal))
        .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Palette.ash, lineWidth: 1))
    }

    @ViewBuilder
    private var savedSection: some View {
        if library.favoriteEntries.isEmpty {
            EmptyStateView(
                symbol: "bookmark.slash",
                title: "Nothing saved yet",
                message: "Tap the bookmark on any monster, myth or realm to keep it here for your descent.",
                actionTitle: nil
            )
            .padding(.top, 30)
        } else {
            LazyVStack(spacing: 12) {
                ForEach(library.favoriteEntries) { entry in
                    NavigationLink(value: entry) {
                        LoreCard(entry: entry, isFavorite: true)
                    }
                    .buttonStyle(.pressable)
                }
            }
        }
    }

    @ViewBuilder
    private var historySection: some View {
        if library.history.isEmpty {
            EmptyStateView(
                symbol: "clock.arrow.circlepath",
                title: "No path walked yet",
                message: "As you explore the underworld, take the Gate test or challenge the quiz, your journey will be recorded here.",
                actionTitle: nil
            )
            .padding(.top, 30)
        } else {
            VStack(spacing: 12) {
                HStack {
                    Text("\(library.history.count) events")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Palette.smoke)
                    Spacer()
                    Button("Clear") {
                        Haptics.warning()
                        withAnimation { library.clearHistory() }
                    }
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Palette.crimson)
                }
                ForEach(library.history) { event in
                    HistoryRow(event: event)
                }
            }
        }
    }
}

#Preview {
    LibraryView()
        .environment(LibraryStore())
        .environment(SubscriptionManager())
}
