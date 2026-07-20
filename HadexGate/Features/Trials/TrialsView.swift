//
//  TrialsView.swift
//  HadexGate
//
//  Hub for the two interactive trials: the Gate judgment test and the dark quiz.
//

import SwiftUI

struct TrialsView: View {
    @Environment(LibraryStore.self) private var library

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    intro

                    standingCard

                    NavigationLink {
                        GateTestView()
                    } label: {
                        trialCard(
                            symbol: "door.left.hand.open",
                            kicker: "Judgment",
                            title: "The Gate of Hades",
                            body: "Answer as the ancient judges would ask. Discover whether your soul earns Elysium, drifts to Asphodel, or falls to Tartarus.",
                            gradient: Gradients.gold,
                            tint: Palette.gold
                        )
                    }
                    .buttonStyle(.pressable)

                    NavigationLink {
                        QuizView()
                    } label: {
                        trialCard(
                            symbol: "checkmark.seal.fill",
                            kicker: "Knowledge",
                            title: "Quiz of the Dark",
                            body: "Name the monster, the slayer, the myth. Twelve questions drawn from the deepest corners of Greek legend.",
                            gradient: Gradients.blood,
                            tint: Palette.crimson
                        )
                    }
                    .buttonStyle(.pressable)

                    SphinxRiddleCard()

                    factsStrip

                    Color.clear.frame(height: 96)
                }
                .padding(.horizontal, Metrics.screenPadding)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .hadexBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Trials of the Gate")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Palette.bone)
                }
            }
        }
    }

    private var intro: some View {
        VStack(spacing: 8) {
            IconBadge(symbol: "die.face.5.fill", tint: Palette.ember, size: 58)
            Text("Prove yourself before the gate")
                .font(.title3.weight(.bold))
                .foregroundStyle(Palette.bone)
                .multilineTextAlignment(.center)
            Text("Two trials await, seeker — one of the soul, one of the mind.")
                .font(.subheadline)
                .foregroundStyle(Palette.boneMuted)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 8)
    }

    private func trialCard(symbol: String, kicker: String, title: String, body: String,
                           gradient: LinearGradient, tint: Color) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(gradient)
                    .frame(width: 66, height: 66)
                Image(systemName: symbol)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(LocalizedStringKey(kicker)).textCase(.uppercase)
                    .font(.caption2.weight(.bold))
                    .tracking(2)
                    .foregroundStyle(tint)
                Text(LocalizedStringKey(title))
                    .font(.headline)
                    .foregroundStyle(Palette.bone)
                Text(LocalizedStringKey(body))
                    .font(.caption)
                    .foregroundStyle(Palette.boneMuted)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                .fill(Gradients.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                .stroke(tint.opacity(0.4), lineWidth: 1)
        )
    }

    // MARK: - Standing (stats from history)

    private var quizzesTaken: Int { library.history.filter { $0.kind == .quiz }.count }
    private var gatesJudged: Int { library.history.filter { $0.kind == .gate }.count }

    /// Best quiz score parsed from history titles like "Scored 9/12".
    private var bestQuiz: String {
        let scores: [Int] = library.history.compactMap { event in
            guard event.kind == .quiz else { return nil }
            let parts = event.title.replacingOccurrences(of: "Scored ", with: "").split(separator: "/")
            return parts.first.flatMap { Int($0) }
        }
        guard let best = scores.max() else { return "—" }
        return "\(best)/\(QuizLibrary.questions.count)"
    }

    private var standingCard: some View {
        SurfaceCard(tint: Palette.gold) {
            VStack(alignment: .leading, spacing: 14) {
                SectionHeader(title: "Your Standing", subtitle: "Your record before the gate", systemImage: "rosette")
                HStack(spacing: 10) {
                    statTile(value: "\(gatesJudged)", label: "Souls Judged", icon: "door.left.hand.open", tint: Palette.gold)
                    statTile(value: "\(quizzesTaken)", label: "Quizzes", icon: "checkmark.seal.fill", tint: Palette.crimson)
                    statTile(value: bestQuiz, label: "Best Score", icon: "trophy.fill", tint: Palette.ember)
                }
            }
        }
    }

    private func statTile(value: String, label: String, icon: String, tint: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(tint)
            Text(LocalizedStringKey(value))
                .font(.title3.weight(.heavy))
                .foregroundStyle(Palette.bone)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(LocalizedStringKey(label))
                .font(.caption2)
                .foregroundStyle(Palette.boneMuted)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Palette.charcoal.opacity(0.7))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(tint.opacity(0.3), lineWidth: 1)
        )
    }

    private var factsStrip: some View {
        SurfaceCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Did you know?", systemImage: "lightbulb.fill")
                Text("The Greeks buried their dead with a coin for Charon and, at the Eleusinian Mysteries, hoped to learn secrets that would spare their souls the grey fate of the Asphodel Meadows.")
                    .font(.subheadline)
                    .foregroundStyle(Palette.boneMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Sphinx's Riddle (interactive)

private struct SphinxRiddle {
    let riddle: String
    let answer: String
}

private struct SphinxRiddleCard: View {
    private let riddles: [SphinxRiddle] = [
        SphinxRiddle(riddle: "What walks on four legs at dawn, two at noon, and three at dusk?",
                     answer: "Man — crawling as a babe, upright in his prime, leaning on a staff in old age. This is the riddle Oedipus answered."),
        SphinxRiddle(riddle: "There are two sisters: the first gives birth to the second, and the second to the first. Who are they?",
                     answer: "Day and Night — each forever born from the other. The Sphinx's lesser-known second riddle."),
        SphinxRiddle(riddle: "I am laid upon the tongue of the dead, worthless to the living rich. What am I?",
                     answer: "The obol — the coin of passage, payment for Charon to ferry a soul across the river of the dead."),
        SphinxRiddle(riddle: "I have no body, yet I bind even the gods. To break me is to be cast from Olympus. What am I?",
                     answer: "An oath sworn upon the river Styx — unbreakable even for the immortals."),
    ]

    @State private var index = 0
    @State private var revealed = false

    var body: some View {
        SurfaceCard(tint: Palette.violet) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    SectionHeader(title: "Riddle of the Sphinx", systemImage: "questionmark.diamond.fill")
                    Spacer()
                    Button {
                        Haptics.tap()
                        withAnimation(.easeInOut(duration: 0.25)) {
                            revealed = false
                            index = (index + 1) % riddles.count
                        }
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundStyle(Palette.violet)
                    }
                    .buttonStyle(.pressable)
                }

                Text("“\(riddles[index].riddle)”")
                    .font(.callout.italic())
                    .foregroundStyle(Palette.bone)
                    .fixedSize(horizontal: false, vertical: true)

                if revealed {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "key.fill").foregroundStyle(Palette.gold)
                        Text(LocalizedStringKey(riddles[index].answer))
                            .font(.footnote)
                            .foregroundStyle(Palette.boneMuted)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Palette.slate.opacity(0.7)))
                    .transition(.opacity.combined(with: .move(edge: .top)))
                } else {
                    Button {
                        Haptics.tap(.medium)
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { revealed = true }
                    } label: {
                        HStack {
                            Image(systemName: "eye.fill")
                            Text("Reveal the Answer")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Palette.bone)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Palette.violet.opacity(0.25)))
                        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Palette.violet.opacity(0.5), lineWidth: 1))
                    }
                    .buttonStyle(.pressable)
                }
            }
        }
    }
}

#Preview {
    TrialsView()
        .environment(LibraryStore())
}
