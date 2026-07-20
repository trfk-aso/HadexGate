//
//  LoreCategory.swift
//  HadexGate
//

import SwiftUI

enum LoreCategory: String, CaseIterable, Identifiable, Codable {
    case realm       // regions of the underworld
    case river       // the five rivers of the dead
    case guardian    // Charon, Cerberus, the judges
    case monster     // the bestiary
    case hero        // those who descended
    case punishment  // the torments of Tartarus
    case deity       // Hades, Persephone

    var id: String { rawValue }

    var title: String {
        switch self {
        case .realm: return "Realms"
        case .river: return "Rivers of the Dead"
        case .guardian: return "Guardians"
        case .monster: return "Bestiary"
        case .hero: return "Descents"
        case .punishment: return "Torments"
        case .deity: return "Rulers"
        }
    }

    var singular: String {
        switch self {
        case .realm: return "Realm"
        case .river: return "River"
        case .guardian: return "Guardian"
        case .monster: return "Monster"
        case .hero: return "Descent"
        case .punishment: return "Torment"
        case .deity: return "Ruler"
        }
    }

    var blurb: String {
        switch self {
        case .realm: return "Where the dead dwell — paradise, plains and pit"
        case .river: return "Five waters the soul must cross"
        case .guardian: return "Those who bar the way"
        case .monster: return "Legendary horrors of the ancient world"
        case .hero: return "The living who dared to enter"
        case .punishment: return "Eternal suffering in the abyss"
        case .deity: return "The lord and lady of the dead"
        }
    }

    var symbol: String {
        switch self {
        case .realm: return "map.fill"
        case .river: return "water.waves"
        case .guardian: return "shield.lefthalf.filled"
        case .monster: return "pawprint.fill"
        case .hero: return "figure.walk.motion"
        case .punishment: return "flame.fill"
        case .deity: return "crown.fill"
        }
    }

    var tint: Color {
        switch self {
        case .realm: return Palette.gold
        case .river: return Palette.styx
        case .guardian: return Palette.emberBright
        case .monster: return Palette.crimson
        case .hero: return Palette.ember
        case .punishment: return Palette.blood
        case .deity: return Palette.violet
        }
    }

    var artworkTint: ArtworkTint {
        switch self {
        case .realm: return .gold
        case .river: return .river
        case .guardian: return .ember
        case .monster: return .blood
        case .hero: return .ember
        case .punishment: return .blood
        case .deity: return .spirit
        }
    }
}
