//
//  GateTestView.swift
//  HadexGate
//
//  The Gate of Hades judgment test — the primary interactive working screen.
//

import SwiftUI

struct GateTestView: View {
    @Environment(LibraryStore.self) private var library
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let questions = GateLibrary.questions
    @State private var index = 0
    @State private var choices: [GateVerdict] = []
    @State private var selectedOption: UUID? = nil
    @State private var result: GateVerdict? = nil

    var body: some View {
        Group {
            if let result {
                GateResultView(verdict: result) {
                    restart()
                }
            } else {
                testBody
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var testBody: some View {
        VStack(spacing: 22) {
            progressBar

            Spacer(minLength: 0)

            let question = questions[index]

            VStack(spacing: 18) {
                IconBadge(symbol: question.symbol, tint: Palette.gold, size: 66)

                Text(LocalizedStringKey(question.prompt))
                    .font(.system(.title2, design: .serif).weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Palette.bone)
                    .fixedSize(horizontal: false, vertical: true)
                    .id(question.id)
                    .transition(reduceMotion ? .opacity : .move(edge: .trailing).combined(with: .opacity))
            }
            .padding(.horizontal, 8)

            Spacer(minLength: 0)

            VStack(spacing: 12) {
                ForEach(question.options) { option in
                    optionButton(option)
                }
            }
            Color.clear.frame(height: 90)
        }
        .padding(.horizontal, Metrics.screenPadding)
        .padding(.top, 12)
        .frame(maxHeight: .infinity)
        .hadexBackground()
        .navigationTitle("The Gate of Hades")
    }

    private var progressBar: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Question \(index + 1) of \(questions.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Palette.boneMuted)
                Spacer()
                Image(systemName: "scalemass.fill")
                    .font(.caption)
                    .foregroundStyle(Palette.gold)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Palette.ash)
                    Capsule().fill(Gradients.gold)
                        .frame(width: geo.size.width * CGFloat(index + 1) / CGFloat(questions.count))
                }
            }
            .frame(height: 8)
        }
    }

    private func optionButton(_ option: GateOption) -> some View {
        Button {
            answer(option)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: selectedOption == option.id ? "circle.inset.filled" : "circle")
                    .foregroundStyle(selectedOption == option.id ? Palette.gold : Palette.smoke)
                Text(LocalizedStringKey(option.text))
                    .font(.callout.weight(.medium))
                    .foregroundStyle(Palette.bone)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(selectedOption == option.id ? Palette.gold.opacity(0.16) : Palette.charcoal)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(selectedOption == option.id ? Palette.gold.opacity(0.6) : Palette.ash, lineWidth: 1)
            )
        }
        .buttonStyle(.pressable)
    }

    private func answer(_ option: GateOption) {
        Haptics.tap(.medium)
        selectedOption = option.id
        // Weight the choice.
        for _ in 0..<option.weight { choices.append(option.verdict) }

        Task {
            try? await Task.sleep(for: .milliseconds(280))
            withAnimation(reduceMotion ? .easeInOut(duration: 0.25) : .spring(response: 0.4, dampingFraction: 0.8)) {
                if index + 1 < questions.count {
                    index += 1
                    selectedOption = nil
                } else {
                    finish()
                }
            }
        }
    }

    private func finish() {
        let verdict = GateLibrary.verdict(from: choices)
        result = verdict
        library.record(HistoryEvent(kind: .gate, title: verdict.shortName,
                                    detail: "The gate judged your soul", date: Date()))
        Haptics.success()
    }

    private func restart() {
        withAnimation(.easeInOut) {
            index = 0
            choices = []
            selectedOption = nil
            result = nil
        }
    }
}

#Preview {
    NavigationStack { GateTestView() }
        .environment(LibraryStore())
}
