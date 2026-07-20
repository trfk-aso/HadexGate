//
//  LibraryStore.swift
//  HadexGate
//
//  Owns the user's saved items and action history, persisted to UserDefaults.
//  Injected once from @main and read via the environment.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class LibraryStore {
    private(set) var favoriteIDs: Set<String> = []
    private(set) var history: [HistoryEvent] = []

    private let favoritesKey = "hadex.favorites.v1"
    private let historyKey = "hadex.history.v1"
    private let defaults = UserDefaults.standard

    init() {
        load()
    }

    // MARK: - Favorites

    func isFavorite(_ id: String) -> Bool {
        favoriteIDs.contains(id)
    }

    func toggleFavorite(_ entry: LoreEntry) {
        if favoriteIDs.contains(entry.id) {
            favoriteIDs.remove(entry.id)
        } else {
            favoriteIDs.insert(entry.id)
            Haptics.success()
        }
        persistFavorites()
    }

    var favoriteEntries: [LoreEntry] {
        LoreLibrary.all.filter { favoriteIDs.contains($0.id) }
    }

    // MARK: - History

    func record(_ event: HistoryEvent) {
        // Avoid stacking identical consecutive "viewed" events.
        if let last = history.first,
           last.kind == event.kind,
           last.title == event.title,
           event.date.timeIntervalSince(last.date) < 3 {
            return
        }
        history.insert(event, at: 0)
        if history.count > 60 {
            history = Array(history.prefix(60))
        }
        persistHistory()
    }

    func recordView(_ entry: LoreEntry) {
        record(HistoryEvent(kind: .viewed, title: entry.name,
                            detail: entry.category.singular, date: Date()))
    }

    func clearHistory() {
        history.removeAll()
        persistHistory()
    }

    var recentEvents: [HistoryEvent] {
        Array(history.prefix(12))
    }

    // MARK: - Persistence

    private func persistFavorites() {
        defaults.set(Array(favoriteIDs), forKey: favoritesKey)
    }

    private func persistHistory() {
        if let data = try? JSONEncoder().encode(history) {
            defaults.set(data, forKey: historyKey)
        }
    }

    private func load() {
        if let ids = defaults.array(forKey: favoritesKey) as? [String] {
            favoriteIDs = Set(ids)
        }
        if let data = defaults.data(forKey: historyKey),
           let events = try? JSONDecoder().decode([HistoryEvent].self, from: data) {
            history = events
        }
    }
}
