//
//  LoreEntry.swift
//  HadexGate
//
//  The unified content model for every lore-able entity: realms, rivers,
//  guardians, monsters, heroes, torments and rulers.
//

import Foundation

struct Fact: Identifiable, Hashable, Codable {
    var id = UUID()
    let icon: String
    let label: String
    let value: String
}

struct LoreSection: Identifiable, Hashable, Codable {
    var id = UUID()
    let title: String
    let body: String
}

struct LoreEntry: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let epithet: String
    let category: LoreCategory
    let summary: String
    let facts: [Fact]
    let sections: [LoreSection]
    let tags: [String]
    let artwork: ArtworkStyle
    /// Short, punchy hook used on feature banners.
    var hook: String = ""

    var searchText: String {
        (name + " " + epithet + " " + summary + " " + tags.joined(separator: " ")).lowercased()
    }
}
