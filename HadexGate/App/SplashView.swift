//
//  SplashView.swift
//  HadexGate
//
//  Opening sequence. Driven by an `onComplete` callback (never a @Binding); the
//  callback fires only after the animation completes (min. 3 seconds).
//

import SwiftUI

struct SplashView: View {
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var gateOpen = false
    @State private var titleShown = false
    @State private var glowPulse = false
    @State private var ringScale = 0.6

    var body: some View {
        ZStack {
            AppBackground(emberCount: 40)

            // Expanding glow behind the gate.
            Circle()
                .fill(Gradients.glow(Palette.ember))
                .frame(width: 320, height: 320)
                .scaleEffect(glowPulse ? 1.15 : 0.85)
                .opacity(0.9)

            // Concentric rune rings.
            ForEach(0..<3) { i in
                Circle()
                    .stroke(
                        LinearGradient(colors: [Palette.gold.opacity(0.6), Palette.ember.opacity(0.1)],
                                       startPoint: .top, endPoint: .bottom),
                        lineWidth: 1.5
                    )
                    .frame(width: 150 + CGFloat(i) * 66, height: 150 + CGFloat(i) * 66)
                    .scaleEffect(ringScale)
                    .opacity(gateOpen ? 0.9 : 0)
            }

            // The gate: two halves parting.
            gate

            VStack(spacing: 10) {
                Spacer()
                Text("HADEX GATE")
                    .font(.system(.largeTitle, design: .serif).weight(.heavy))
                    .tracking(6)
                    .foregroundStyle(Gradients.gold)
                    .opacity(titleShown ? 1 : 0)
                    .offset(y: titleShown ? 0 : 16)
                Text("Enter the Greek Underworld")
                    .font(.footnote.weight(.medium))
                    .tracking(3)
                    .textCase(.uppercase)
                    .foregroundStyle(Palette.boneMuted)
                    .opacity(titleShown ? 1 : 0)
                Spacer().frame(height: 80)
            }
            .padding()
        }
        .task {
            await runSequence()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Hadex Gate. Enter the Greek underworld.")
    }

    private var gate: some View {
        ZStack {
            Image(systemName: "flame.fill")
                .font(.system(size: 64, weight: .light))
                .foregroundStyle(Gradients.ember)
                .opacity(gateOpen ? 1 : 0)
                .scaleEffect(gateOpen ? 1 : 0.4)
                .shadow(color: Palette.ember.opacity(0.8), radius: 24)

            HStack(spacing: gateOpen ? 120 : 0) {
                gateHalf(leading: true)
                gateHalf(leading: false)
            }
        }
    }

    private func gateHalf(leading: Bool) -> some View {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(
                LinearGradient(colors: [Palette.slate, Palette.charcoal, Palette.abyss],
                               startPoint: .top, endPoint: .bottom)
            )
            .frame(width: 66, height: 210)
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(Palette.gold.opacity(0.35), lineWidth: 1)
            )
            .overlay(
                Image(systemName: leading ? "laurel.leading" : "laurel.trailing")
                    .font(.title2)
                    .foregroundStyle(Palette.gold.opacity(0.5))
            )
            .opacity(gateOpen ? 0 : 1)
    }

    private func runSequence() async {
        if reduceMotion {
            // Respect Reduce Motion — a calm fade instead of the full sequence.
            withAnimation(.easeIn(duration: 0.5)) {
                gateOpen = true
                titleShown = true
                glowPulse = true
                ringScale = 1
            }
            try? await Task.sleep(for: .seconds(3))
            onComplete()
            return
        }

        withAnimation(.easeOut(duration: 1.0)) {
            glowPulse = true
        }
        try? await Task.sleep(for: .milliseconds(500))
        withAnimation(.spring(response: 1.2, dampingFraction: 0.7)) {
            gateOpen = true
            ringScale = 1
        }
        try? await Task.sleep(for: .milliseconds(700))
        withAnimation(.easeOut(duration: 0.8)) {
            titleShown = true
        }
        withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
            glowPulse.toggle()
        }
        // Hold on the finished composition; total ~3.4s before handing off.
        try? await Task.sleep(for: .milliseconds(1500))
        onComplete()
    }
}

#Preview {
    SplashView(onComplete: {})
}
