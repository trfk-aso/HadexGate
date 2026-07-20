//
//  LoreCollection.swift
//  HadexGate
//

import Foundation

struct LoreCollection: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let symbol: String
    let tint: ArtworkTint
    let entryIDs: [String]

    var entries: [LoreEntry] {
        entryIDs.compactMap { LoreLibrary.entry(id: $0) }
    }
}

enum CollectionsLibrary {
    static let all: [LoreCollection] = [
        LoreCollection(
            id: "battles",
            title: "Legendary Battles",
            subtitle: "How heroes brought down the monsters of myth",
            symbol: "figure.fencing",
            tint: .ember,
            entryIDs: ["medusa", "minotaur", "hydra", "chimera", "sphinx", "scylla-charybdis"]
        ),
        LoreCollection(
            id: "descents",
            title: "The Living Who Descended",
            subtitle: "Those who entered the land of the dead — and what befell them",
            symbol: "figure.walk.motion",
            tint: .spirit,
            entryIDs: ["orpheus", "heracles", "odysseus", "theseus", "psyche", "dionysus"]
        ),
        LoreCollection(
            id: "torments",
            title: "The Torments of Tartarus",
            subtitle: "Eternal punishments, and the crimes that earned them",
            symbol: "flame.fill",
            tint: .blood,
            entryIDs: ["sisyphus", "tantalus", "prometheus", "ixion", "danaids", "tityos"]
        ),
        LoreCollection(
            id: "rivers",
            title: "The Five Rivers",
            subtitle: "The waters every soul must reckon with",
            symbol: "water.waves",
            tint: .river,
            entryIDs: ["styx", "lethe", "acheron", "cocytus", "phlegethon"]
        ),
        LoreCollection(
            id: "map",
            title: "Map of the Underworld",
            subtitle: "The geography of the dead, region by region",
            symbol: "map.fill",
            tint: .gold,
            entryIDs: ["erebus", "asphodel", "elysium", "mourning-fields", "tartarus", "isles-blessed"]
        ),
        LoreCollection(
            id: "gatekeepers",
            title: "Keepers of the Gate",
            subtitle: "Those who bar, judge, and guide the dead",
            symbol: "shield.lefthalf.filled",
            tint: .ember,
            entryIDs: ["charon", "cerberus", "judges", "furies", "thanatos", "hecate"]
        ),
    ]
}
