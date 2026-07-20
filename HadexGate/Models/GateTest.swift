//
//  GateTest.swift
//  HadexGate
//
//  The "Gates of Hades" personal judgment test.
//

import SwiftUI

enum GateVerdict: String, CaseIterable, Identifiable, Codable {
    case elysium
    case asphodel
    case tartarus

    var id: String { rawValue }

    var title: String {
        switch self {
        case .elysium: return "The Fields of Elysium"
        case .asphodel: return "The Asphodel Meadows"
        case .tartarus: return "The Pit of Tartarus"
        }
    }

    var shortName: String {
        switch self {
        case .elysium: return "Elysium"
        case .asphodel: return "Asphodel"
        case .tartarus: return "Tartarus"
        }
    }

    var verdictLine: String {
        switch self {
        case .elysium: return "The judges rise. You are worthy of paradise."
        case .asphodel: return "You walk with the countless many, neither blessed nor damned."
        case .tartarus: return "The bronze gates groan open. There is no return."
        }
    }

    var summary: String {
        switch self {
        case .elysium:
            return "Reserved for heroes, the virtuous and those beloved of the gods. Here the sun still shines, the air is soft, and the blessed dead feast and contest among golden meadows. Some traditions promise the truly righteous rebirth — and after three worthy lives, passage to the Isles of the Blessed."
        case .asphodel:
            return "The vast grey plain where ordinary souls drift among pale asphodel flowers. They are not punished, but they are not rewarded — they linger as shades, their memories dimmed by the waters of Lethe, echoing the lives they once led."
        case .tartarus:
            return "A gloom as far below Hades as the earth lies below the sky. Here the great sinners who defied the gods endure torment without end, sealed behind bronze walls and a triple ring of night. It is a prison, not a grave."
        }
    }

    var traits: [String] {
        switch self {
        case .elysium: return ["Courageous", "Just", "Honoured", "Beloved of the gods"]
        case .asphodel: return ["Ordinary", "Balanced", "Unremarkable in deed", "Quietly mortal"]
        case .tartarus: return ["Defiant", "Prideful", "Deceiver of gods", "Unrepentant"]
        }
    }

    var symbol: String {
        switch self {
        case .elysium: return "laurel.leading"
        case .asphodel: return "aqi.medium"
        case .tartarus: return "flame.fill"
        }
    }

    var artwork: ArtworkStyle {
        switch self {
        case .elysium: return ArtworkStyle(symbol: "laurel.leading", tint: .gold, seed: 9001)
        case .asphodel: return ArtworkStyle(symbol: "aqi.medium", tint: .spirit, seed: 9002)
        case .tartarus: return ArtworkStyle(symbol: "flame.fill", tint: .blood, seed: 9003)
        }
    }

    var tint: Color {
        switch self {
        case .elysium: return Palette.gold
        case .asphodel: return Palette.violet
        case .tartarus: return Palette.blood
        }
    }
}

struct GateOption: Identifiable, Hashable {
    var id = UUID()
    let text: String
    let verdict: GateVerdict
    /// How strongly this answer weighs toward its verdict.
    let weight: Int
}

struct GateQuestion: Identifiable, Hashable {
    let id: String
    let prompt: String
    let symbol: String
    let options: [GateOption]
}
