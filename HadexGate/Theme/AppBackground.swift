//
//  AppBackground.swift
//  HadexGate
//
//  The shared living background — an ember-lit abyss with drifting embers,
//  used behind every screen so the whole product feels like one place.
//

import SwiftUI

struct AppBackground: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage("hadex.embersEnabled") private var embersEnabled = true
    var emberCount: Int = 26
    @State private var animate = false

    var body: some View {
        ZStack {
            Gradients.background
                .ignoresSafeArea()

            // Warm glow rising from the depths.
            Gradients.glow(Palette.ember.opacity(0.5))
                .frame(width: 520, height: 520)
                .blur(radius: 40)
                .offset(y: 260)
                .ignoresSafeArea()

            Gradients.glow(Palette.violet.opacity(0.35))
                .frame(width: 420, height: 420)
                .blur(radius: 50)
                .offset(x: -140, y: -260)
                .ignoresSafeArea()

            if embersEnabled {
                EmberField(count: emberCount, animate: animate && !reduceMotion)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

/// A slow drift of glowing embers rendered efficiently with Canvas + TimelineView.
private struct EmberField: View {
    let count: Int
    let animate: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: !animate)) { timeline in
            Canvas { context, size in
                let t = timeline.date.timeIntervalSinceReferenceDate
                for i in 0..<count {
                    let seed = Double(i)
                    let speed = 0.15 + (seed.truncatingRemainder(dividingBy: 5) / 12)
                    let baseX = (seed * 97).truncatingRemainder(dividingBy: 1) * size.width
                    let drift = sin(t * speed + seed) * 18
                    let x = (baseX + drift).truncatingRemainder(dividingBy: size.width)
                    let phase = (t * speed + seed * 13).truncatingRemainder(dividingBy: size.height + 120)
                    let y = size.height + 60 - phase
                    let radius = 1.2 + (seed.truncatingRemainder(dividingBy: 3))
                    let flicker = 0.35 + 0.4 * (0.5 + 0.5 * sin(t * 2 + seed * 5))
                    let rect = CGRect(x: x, y: y, width: radius * 2, height: radius * 2)
                    let color = i % 4 == 0 ? Palette.gold : Palette.ember
                    context.fill(Path(ellipseIn: rect), with: .color(color.opacity(flicker)))
                }
            }
        }
    }
}

/// Convenience modifier applying the app background behind any screen.
extension View {
    func hadexBackground(emberCount: Int = 26) -> some View {
        background(AppBackground(emberCount: emberCount))
    }
}
