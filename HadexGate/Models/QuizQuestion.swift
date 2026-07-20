//
//  QuizQuestion.swift
//  HadexGate
//

import Foundation

struct QuizQuestion: Identifiable, Hashable, Codable {
    let id: String
    let prompt: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
    /// Symbol shown on the question card.
    let symbol: String
    let tint: ArtworkTint
}
