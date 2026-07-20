//
//  GateLibrary.swift
//  HadexGate
//
//  Questions for the "Gates of Hades" judgment test. Each answer weighs the
//  soul toward Elysium, Asphodel or Tartarus.
//

import Foundation

enum GateLibrary {
    static let questions: [GateQuestion] = [
        GateQuestion(
            id: "g1",
            prompt: "A stranger arrives at your door, cold and hungry. You…",
            symbol: "door.left.hand.open",
            options: [
                GateOption(text: "Take them in and share your last meal", verdict: .elysium, weight: 2),
                GateOption(text: "Point them to the nearest inn", verdict: .asphodel, weight: 2),
                GateOption(text: "Turn them away — their trouble is not yours", verdict: .tartarus, weight: 2),
            ]
        ),
        GateQuestion(
            id: "g2",
            prompt: "You are offered great power, but it requires betraying a friend. You…",
            symbol: "hand.raised.fill",
            options: [
                GateOption(text: "Refuse — loyalty is worth more than power", verdict: .elysium, weight: 2),
                GateOption(text: "Hesitate, then walk away from both", verdict: .asphodel, weight: 1),
                GateOption(text: "Take the power. Friends are replaceable", verdict: .tartarus, weight: 2),
            ]
        ),
        GateQuestion(
            id: "g3",
            prompt: "How will the living remember your name?",
            symbol: "scroll.fill",
            options: [
                GateOption(text: "For a bold deed that helped many", verdict: .elysium, weight: 2),
                GateOption(text: "Quietly, by those who knew me", verdict: .asphodel, weight: 2),
                GateOption(text: "With fear, or a curse", verdict: .tartarus, weight: 2),
            ]
        ),
        GateQuestion(
            id: "g4",
            prompt: "The gods themselves test your pride. You…",
            symbol: "crown.fill",
            options: [
                GateOption(text: "Bow — I know my place beneath them", verdict: .elysium, weight: 1),
                GateOption(text: "Nod politely and keep to myself", verdict: .asphodel, weight: 2),
                GateOption(text: "Boast that I am their equal", verdict: .tartarus, weight: 3),
            ]
        ),
        GateQuestion(
            id: "g5",
            prompt: "You find a purse of gold on an empty road. You…",
            symbol: "bag.fill",
            options: [
                GateOption(text: "Search for its owner to return it", verdict: .elysium, weight: 2),
                GateOption(text: "Leave it where it lies", verdict: .asphodel, weight: 2),
                GateOption(text: "Keep it and tell no one", verdict: .tartarus, weight: 1),
            ]
        ),
        GateQuestion(
            id: "g6",
            prompt: "When wronged, you…",
            symbol: "flame.fill",
            options: [
                GateOption(text: "Forgive, and seek to understand", verdict: .elysium, weight: 2),
                GateOption(text: "Let it go with time", verdict: .asphodel, weight: 2),
                GateOption(text: "Repay it tenfold, whatever it takes", verdict: .tartarus, weight: 2),
            ]
        ),
        GateQuestion(
            id: "g7",
            prompt: "What did you do with the one life you were given?",
            symbol: "hourglass",
            options: [
                GateOption(text: "Risked it for something greater than myself", verdict: .elysium, weight: 3),
                GateOption(text: "Lived it simply and honestly", verdict: .asphodel, weight: 2),
                GateOption(text: "Took whatever I could, however I could", verdict: .tartarus, weight: 2),
            ]
        ),
    ]

    /// Weighs answers and returns the dominant verdict.
    static func verdict(from choices: [GateVerdict]) -> GateVerdict {
        var scores: [GateVerdict: Int] = [:]
        for choice in choices {
            scores[choice, default: 0] += 1
        }
        // Elysium requires genuine virtue; ties fall to the humbler fate.
        let ordered: [GateVerdict] = [.asphodel, .elysium, .tartarus]
        return ordered.max { (scores[$0] ?? 0) < (scores[$1] ?? 0) } ?? .asphodel
    }
}
