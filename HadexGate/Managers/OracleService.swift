//
//  OracleService.swift
//  HadexGate
//
//  The AI "Keeper of the Gate". Uses Apple Intelligence (Foundation Models,
//  on-device) when the device supports it; otherwise falls back to a curated
//  knowledge engine drawn from the app's own lore so the guide always answers.
//

import SwiftUI
import Observation

#if canImport(FoundationModels)
import FoundationModels
#endif

@MainActor
@Observable
final class OracleService {

    enum Engine: Equatable {
        case appleIntelligence
        case keepersArchive   // curated fallback

        var label: String {
            switch self {
            case .appleIntelligence: return "Apple Intelligence"
            case .keepersArchive: return "Keeper's Archive"
            }
        }

        var note: String {
            switch self {
            case .appleIntelligence:
                return "Answering with on-device Apple Intelligence."
            case .keepersArchive:
                return "Apple Intelligence isn't available here — answering from the Keeper's own archive of lore."
            }
        }
    }

    private(set) var messages: [OracleMessage] = []
    private(set) var isResponding = false
    private(set) var engine: Engine = .keepersArchive

    // Free tier: a handful of questions before the Oracle unlock is needed.
    let freeAskLimit = 3
    private(set) var freeAsksUsed = 0
    private let freeAsksKey = "hadex.oracle.freeAsks"

    func remainingFreeAsks() -> Int { max(0, freeAskLimit - freeAsksUsed) }

    func registerFreeAsk() {
        freeAsksUsed += 1
        UserDefaults.standard.set(freeAsksUsed, forKey: freeAsksKey)
    }

    /// Prompts shown as tappable suggestions.
    let suggestions = [
        "What did Tartarus look like?",
        "Is the coin for Charon real?",
        "Who defeated Medusa?",
        "Why does Sisyphus push the boulder forever?",
        "How did Orpheus lose Eurydice?",
        "Why does winter come?",
    ]

    #if canImport(FoundationModels)
    @ObservationIgnored private var _session: Any?
    #endif

    init() {
        detectEngine()
        freeAsksUsed = UserDefaults.standard.integer(forKey: freeAsksKey)
        messages = [
            OracleMessage(
                role: .oracle,
                text: "I am the Keeper of the Gate. Ask what you will of the underworld — its rivers, its monsters, its judged and its damned — and I shall answer."
            )
        ]
    }

    private func detectEngine() {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            switch SystemLanguageModel.default.availability {
            case .available:
                engine = .appleIntelligence
            default:
                engine = .keepersArchive
            }
        } else {
            engine = .keepersArchive
        }
        #else
        engine = .keepersArchive
        #endif
    }

    func reset() {
        messages = [
            OracleMessage(
                role: .oracle,
                text: "The gate is quiet once more. Ask again, seeker."
            )
        ]
        #if canImport(FoundationModels)
        _session = nil
        #endif
    }

    func ask(_ question: String) async -> String {
        let trimmed = question.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "" }

        messages.append(OracleMessage(role: .seeker, text: trimmed))
        var thinking = OracleMessage(role: .oracle, text: "", isThinking: true)
        messages.append(thinking)
        isResponding = true
        defer { isResponding = false }

        let answer = await generateAnswer(for: trimmed)

        if let index = messages.firstIndex(where: { $0.id == thinking.id }) {
            thinking.text = answer
            thinking.isThinking = false
            messages[index] = thinking
        }
        return answer
    }

    private func generateAnswer(for question: String) async -> String {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, *), engine == .appleIntelligence {
            if let answer = await answerWithAppleIntelligence(question) {
                return answer
            }
        }
        #endif
        // Small, deliberate delay so the fallback still feels considered.
        try? await Task.sleep(for: .milliseconds(500))
        return KeepersArchive.answer(for: question)
    }

    #if canImport(FoundationModels)
    @available(iOS 26.0, *)
    private func session() -> LanguageModelSession {
        if let existing = _session as? LanguageModelSession {
            return existing
        }
        let instructions = """
        You are the Keeper of the Gate, a wise and atmospheric guide to the ancient \
        Greek underworld and its mythology: the realms of Hades (Elysium, the Asphodel \
        Meadows, Tartarus), the rivers of the dead, Charon, Cerberus, the judges of the \
        dead, the monsters and heroes of Greek myth, and the great torments. \
        Answer only questions about Greek mythology and the underworld. Speak vividly \
        but accurately, in 2 to 4 sentences. If a question is unrelated to Greek myth, \
        gently steer the seeker back to the underworld. Never invent modern facts.
        """
        let newSession = LanguageModelSession(instructions: instructions)
        _session = newSession
        return newSession
    }

    @available(iOS 26.0, *)
    private func answerWithAppleIntelligence(_ question: String) async -> String? {
        do {
            let response = try await session().respond(to: question)
            let text = response.content.trimmingCharacters(in: .whitespacesAndNewlines)
            return text.isEmpty ? nil : text
        } catch {
            return nil
        }
    }
    #endif
}
