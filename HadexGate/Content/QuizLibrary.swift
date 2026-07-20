//
//  QuizLibrary.swift
//  HadexGate
//

import Foundation

enum QuizLibrary {
    static let questions: [QuizQuestion] = [
        QuizQuestion(
            id: "q1",
            prompt: "Which monster grew two new heads for every one that was cut off?",
            options: ["The Chimera", "The Lernaean Hydra", "Medusa", "The Sphinx"],
            correctIndex: 1,
            explanation: "The Hydra regrew doubled heads until Heracles and Iolaus seared each stump with fire.",
            symbol: "allergens",
            tint: .river
        ),
        QuizQuestion(
            id: "q2",
            prompt: "What did the Greeks place with the dead to pay Charon?",
            options: ["A gold ring", "A coin (obol)", "A lock of hair", "A clay tablet"],
            correctIndex: 1,
            explanation: "A coin was placed in or on the mouth of the dead. No coin meant no crossing for a hundred years.",
            symbol: "centsign.circle.fill",
            tint: .ember
        ),
        QuizQuestion(
            id: "q3",
            prompt: "Who slew Medusa without looking directly at her?",
            options: ["Theseus", "Heracles", "Perseus", "Bellerophon"],
            correctIndex: 2,
            explanation: "Perseus used his polished shield as a mirror to strike without meeting her petrifying gaze.",
            symbol: "eye.trianglebadge.exclamationmark.fill",
            tint: .blood
        ),
        QuizQuestion(
            id: "q4",
            prompt: "Why did Orpheus lose Eurydice a second time?",
            options: ["He failed a riddle", "He looked back too soon", "He drank from Lethe", "Charon refused him"],
            correctIndex: 1,
            explanation: "He was forbidden to look back until both had left the underworld — but he turned while she was still in shadow.",
            symbol: "music.mic",
            tint: .ember
        ),
        QuizQuestion(
            id: "q5",
            prompt: "Which realm was the eternal prison of the great sinners and the Titans?",
            options: ["Elysium", "Asphodel", "Tartarus", "Erebus"],
            correctIndex: 2,
            explanation: "Tartarus lies as far below Hades as the sky is above earth — sealed by bronze and triple night.",
            symbol: "flame.fill",
            tint: .blood
        ),
        QuizQuestion(
            id: "q6",
            prompt: "Whose punishment was to roll a boulder uphill for eternity?",
            options: ["Tantalus", "Ixion", "Sisyphus", "Tityos"],
            correctIndex: 2,
            explanation: "Sisyphus cheated death twice; his boulder always rolls back near the summit.",
            symbol: "mountain.2.fill",
            tint: .blood
        ),
        QuizQuestion(
            id: "q7",
            prompt: "How did Theseus find his way out of the Labyrinth?",
            options: ["He flew out", "He followed a thread", "He memorised the maze", "He broke the walls"],
            correctIndex: 1,
            explanation: "Ariadne gave him a ball of thread to unwind, so he could retrace his path after slaying the Minotaur.",
            symbol: "arrow.triangle.branch",
            tint: .blood
        ),
        QuizQuestion(
            id: "q8",
            prompt: "Which river's waters made a soul forget its former life?",
            options: ["The Styx", "The Lethe", "The Phlegethon", "The Cocytus"],
            correctIndex: 1,
            explanation: "Lethe, the river of forgetting, erased memory — necessary before a soul could be reborn.",
            symbol: "wind",
            tint: .spirit
        ),
        QuizQuestion(
            id: "q9",
            prompt: "How did Odysseus survive the song of the Sirens?",
            options: ["He out-sang them", "Wax in the crew's ears, bound to the mast", "He sailed at night", "He wore Hades' helm"],
            correctIndex: 1,
            explanation: "His crew plugged their ears with wax while he was lashed to the mast to hear the song and live.",
            symbol: "waveform.path",
            tint: .spirit
        ),
        QuizQuestion(
            id: "q10",
            prompt: "Why does winter come, according to the myth of Persephone?",
            options: ["Hades freezes the earth", "Demeter mourns her daughter's absence", "Nyx covers the sun", "The Styx overflows"],
            correctIndex: 1,
            explanation: "While Persephone is in the underworld, her mother Demeter grieves and the earth stops growing.",
            symbol: "leaf.fill",
            tint: .spirit
        ),
        QuizQuestion(
            id: "q11",
            prompt: "True or false: Hades was the Greek equivalent of the Devil.",
            options: ["True — he was pure evil", "False — he was a stern but just ruler", "True — he tortured all souls", "False — he ruled the sky"],
            correctIndex: 1,
            explanation: "Hades was not evil. He was a grim, fair keeper of order and of the earth's hidden riches.",
            symbol: "crown.fill",
            tint: .spirit
        ),
        QuizQuestion(
            id: "q12",
            prompt: "Which hero captured Cerberus as his final labour?",
            options: ["Perseus", "Heracles", "Orpheus", "Aeneas"],
            correctIndex: 1,
            explanation: "Heracles overpowered the three-headed hound bare-handed and hauled it into the daylight.",
            symbol: "pawprint.fill",
            tint: .ember
        ),
    ]
}
