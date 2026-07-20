//
//  QuizView.swift
//  HadexGate
//

import SwiftUI

struct QuizView: View {
    @Environment(LibraryStore.self) private var library
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let questions = QuizLibrary.questions
    @State private var index = 0
    @State private var score = 0
    @State private var chosenIndex: Int? = nil
    @State private var locked = false
    @State private var finished = false

    var body: some View {
        Group {
            if finished {
                resultScreen
            } else {
                quizBody
            }
        }
        .hadexBackground()
        .navigationTitle("Quiz of the Dark")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Quiz body

    private var quizBody: some View {
        ScrollView {
            VStack(spacing: 20) {
                progress

                let question = questions[index]

                ArtworkView(style: ArtworkStyle(symbol: question.symbol, tint: question.tint, seed: index * 71 + 5))
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(Palette.ash, lineWidth: 1))

                Text(LocalizedStringKey(question.prompt))
                    .font(.system(.title3, design: .serif).weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Palette.bone)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(spacing: 10) {
                    ForEach(Array(question.options.enumerated()), id: \.offset) { i, option in
                        answerRow(i, option, question)
                    }
                }

                if locked {
                    explanation(question)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    nextButton
                }
                Color.clear.frame(height: 96)
            }
            .padding(.horizontal, Metrics.screenPadding)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
    }

    private var progress: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Question \(index + 1) of \(questions.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Palette.boneMuted)
                Spacer()
                Label("\(score)", systemImage: "checkmark.seal.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Palette.gold)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Palette.ash)
                    Capsule().fill(Gradients.blood)
                        .frame(width: geo.size.width * CGFloat(index + 1) / CGFloat(questions.count))
                }
            }
            .frame(height: 8)
        }
    }

    private func answerRow(_ i: Int, _ option: String, _ question: QuizQuestion) -> some View {
        let isCorrect = i == question.correctIndex
        let isChosen = chosenIndex == i
        let showState = locked && (isChosen || isCorrect)

        var fill: Color = Palette.charcoal
        var stroke: Color = Palette.ash
        var icon = "circle"
        var iconColor = Palette.smoke
        if showState {
            if isCorrect {
                fill = Palette.styx.opacity(0.2); stroke = Palette.styx; icon = "checkmark.circle.fill"; iconColor = Palette.styx
            } else if isChosen {
                fill = Palette.blood.opacity(0.2); stroke = Palette.crimson; icon = "xmark.circle.fill"; iconColor = Palette.crimson
            }
        }

        return Button {
            choose(i, question)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon).foregroundStyle(iconColor)
                Text(LocalizedStringKey(option))
                    .font(.callout.weight(.medium))
                    .foregroundStyle(Palette.bone)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
            .padding(15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(fill))
            .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(stroke, lineWidth: 1))
        }
        .buttonStyle(.pressable)
        .disabled(locked)
    }

    private func explanation(_ question: QuizQuestion) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "text.book.closed.fill")
                .foregroundStyle(Palette.gold)
            Text(LocalizedStringKey(question.explanation))
                .font(.footnote)
                .foregroundStyle(Palette.boneMuted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Palette.slate.opacity(0.7)))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Palette.gold.opacity(0.3), lineWidth: 1))
    }

    private var nextButton: some View {
        Button(index + 1 < questions.count ? "Next Question" : "See Your Score") {
            Haptics.tap(.medium)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                if index + 1 < questions.count {
                    index += 1
                    chosenIndex = nil
                    locked = false
                } else {
                    finish()
                }
            }
        }
        .buttonStyle(.ember)
    }

    // MARK: - Result

    private var resultScreen: some View {
        ScrollView {
            VStack(spacing: 20) {
                let pct = Int(Double(score) / Double(questions.count) * 100)
                ZStack {
                    Circle().stroke(Palette.ash, lineWidth: 14)
                    Circle()
                        .trim(from: 0, to: CGFloat(score) / CGFloat(questions.count))
                        .stroke(Gradients.ember, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    VStack(spacing: 2) {
                        Text("\(score)/\(questions.count)")
                            .font(.system(.largeTitle, design: .rounded).weight(.heavy))
                            .foregroundStyle(Palette.bone)
                        Text("\(pct)%")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Palette.ember)
                    }
                }
                .frame(width: 200, height: 200)
                .padding(.top, 20)

                Text(LocalizedStringKey(rank(pct)))
                    .font(.system(.title2, design: .serif).weight(.bold))
                    .foregroundStyle(Palette.bone)
                Text(LocalizedStringKey(rankNote(pct)))
                    .font(.subheadline)
                    .foregroundStyle(Palette.boneMuted)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)

                SurfaceCard {
                    VStack(spacing: 6) {
                        ParameterRow(icon: "checkmark.seal.fill", label: "Correct answers", value: "\(score) of \(questions.count)", tint: Palette.gold)
                        Divider().overlay(Palette.ash)
                        ParameterRow(icon: "percent", label: "Accuracy", value: "\(pct)%", tint: Palette.ember)
                        Divider().overlay(Palette.ash)
                        ParameterRow(icon: "rosette", label: "Rank", value: rank(pct), tint: Palette.crimson)
                    }
                }

                ShareLink(item: "I scored \(score)/\(questions.count) on the Quiz of the Dark in Hadex Gate. Can you best me among the shades?") {
                    HStack { Image(systemName: "square.and.arrow.up"); Text("Share Score") }
                        .font(.headline).foregroundStyle(Palette.abyss)
                        .frame(maxWidth: .infinity).padding(.vertical, 15)
                        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Gradients.ember))
                }

                Button {
                    Haptics.tap()
                    restart()
                } label: {
                    HStack { Image(systemName: "arrow.counterclockwise"); Text("Play Again") }
                        .font(.headline).foregroundStyle(Palette.bone)
                        .frame(maxWidth: .infinity).padding(.vertical, 15)
                        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Palette.slate))
                        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Palette.ash, lineWidth: 1))
                }
                .buttonStyle(.pressable)

                Color.clear.frame(height: 96)
            }
            .padding(.horizontal, Metrics.screenPadding)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Logic

    private func choose(_ i: Int, _ question: QuizQuestion) {
        guard !locked else { return }
        chosenIndex = i
        locked = true
        if i == question.correctIndex {
            score += 1
            Haptics.success()
        } else {
            Haptics.warning()
        }
        withAnimation(.easeInOut(duration: 0.25)) {}
    }

    private func finish() {
        finished = true
        library.record(HistoryEvent(kind: .quiz, title: "Scored \(score)/\(questions.count)",
                                    detail: "Quiz of the Dark", date: Date()))
    }

    private func restart() {
        withAnimation {
            index = 0; score = 0; chosenIndex = nil; locked = false; finished = false
        }
    }

    private func rank(_ pct: Int) -> String {
        switch pct {
        case 90...: return "Keeper of the Gate"
        case 70..<90: return "Initiate of the Mysteries"
        case 40..<70: return "Wandering Shade"
        default: return "Lost on the Shore"
        }
    }

    private func rankNote(_ pct: Int) -> String {
        switch pct {
        case 90...: return "The dead themselves would seek your counsel. Your knowledge of the underworld is near complete."
        case 70..<90: return "You have walked far into the dark and learned its secrets well. A few mysteries remain."
        case 40..<70: return "You drift between knowing and forgetting, like a soul on the Asphodel plain. Study the lore and return."
        default: return "The ferryman would not know what to make of you. Explore the archives and try the trial again."
        }
    }
}

#Preview {
    NavigationStack { QuizView() }
        .environment(LibraryStore())
}
