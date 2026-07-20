//
//  HistoryEvent.swift
//  HadexGate
//

import Foundation

struct HistoryEvent: Identifiable, Codable, Hashable {
    enum Kind: String, Codable {
        case viewed        // opened a lore entry
        case gate          // completed the gate test
        case quiz          // completed the quiz
        case oracle        // asked the oracle

        var symbol: String {
            switch self {
            case .viewed: return "book.fill"
            case .gate: return "door.left.hand.open"
            case .quiz: return "checkmark.seal.fill"
            case .oracle: return "sparkles"
            }
        }

        var label: String {
            switch self {
            case .viewed: return "Explored"
            case .gate: return "Gate Test"
            case .quiz: return "Quiz"
            case .oracle: return "Oracle"
            }
        }
    }

    var id = UUID()
    let kind: Kind
    let title: String
    let detail: String
    let date: Date
}
