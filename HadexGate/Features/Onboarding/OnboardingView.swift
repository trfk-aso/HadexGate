//
//  OnboardingView.swift
//  HadexGate
//
//  "The Descent" — an original, editorial onboarding. Each page is a stage of
//  descending through the Gate of Hades, framed as an archway you look through
//  into the underworld. Roman-numeral chapters, a custom descent rail, and
//  left-aligned dramatic typography set it apart from a templated walkthrough.
//

import SwiftUI

private struct OnboardingPage: Identifiable {
    let id = UUID()
    let numeral: String
    let artwork: ArtworkStyle
    let kicker: String
    let title: String
    let body: String
}

struct OnboardingView: View {
    let onFinish: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var index = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            numeral: "I",
            artwork: ArtworkStyle(symbol: "flame.fill", tint: .ember, seed: 11, imageName: "art_onb1"),
            kicker: "Cross the Threshold",
            title: "Enter the\nRealm of Hades",
            body: "Descend into the darkest, most spellbinding corner of Greek myth — the ancient underworld, its rivers of the dead, and the gods who rule below."
        ),
        OnboardingPage(
            numeral: "II",
            artwork: ArtworkStyle(symbol: "pawprint.fill", tint: .blood, seed: 12, imageName: "art_onb2"),
            kicker: "Face the Legends",
            title: "Monsters &\nTheir Slayers",
            body: "Medusa, the Hydra, the Minotaur, the Sirens — meet the horrors of antiquity and the heroes who dared bring them down."
        ),
        OnboardingPage(
            numeral: "III",
            artwork: ArtworkStyle(symbol: "door.left.hand.open", tint: .gold, seed: 13, imageName: "art_onb3"),
            kicker: "Learn Your Fate",
            title: "Would You\nPass the Gate?",
            body: "Face the judgment of the ancient court, challenge the quiz of dark myth, and discover where your soul would be sent."
        ),
        OnboardingPage(
            numeral: "IV",
            artwork: ArtworkStyle(symbol: "sparkles", tint: .spirit, seed: 14, imageName: "art_onb4"),
            kicker: "Ask the Keeper",
            title: "Your Guide\nto the Dark",
            body: "Summon the Keeper of the Gate — an intelligent oracle who answers anything about the underworld, its myths and its monsters."
        ),
    ]

    private var isLast: Bool { index == pages.count - 1 }

    var body: some View {
        VStack(spacing: 0) {
            topBar

            TabView(selection: $index) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { i, page in
                    GeometryReader { geo in
                        pageView(page, size: geo.size)
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(reduceMotion ? .none : .easeInOut, value: index)

            bottomControls
        }
        .background(AppBackground(emberCount: 34))
    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack {
            HStack(spacing: 7) {
                Image(systemName: "flame.fill")
                    .font(.caption)
                    .foregroundStyle(Gradients.ember)
                Text("HADEX GATE")
                    .font(.system(.subheadline, design: .serif).weight(.heavy))
                    .tracking(2)
                    .foregroundStyle(Palette.bone)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .padding(.bottom, 4)
    }

    // MARK: - Page

    private func pageView(_ page: OnboardingPage, size: CGSize) -> some View {
        let heroHeight = min(size.height * 0.46, 320)
        return VStack(alignment: .leading, spacing: 0) {
            Spacer(minLength: 8)

            GatewayHero(page: page, animated: !reduceMotion)
                .frame(height: heroHeight)
                .frame(maxWidth: .infinity)

            Spacer(minLength: 16)

            // Chapter marker: numeral · kicker with a gold rule.
            HStack(spacing: 12) {
                Text(page.numeral)
                    .font(.system(.title3, design: .serif).weight(.bold))
                    .foregroundStyle(page.artwork.tint.key)
                Rectangle()
                    .fill(LinearGradient(colors: [page.artwork.tint.key, .clear],
                                         startPoint: .leading, endPoint: .trailing))
                    .frame(width: 46, height: 1.5)
                Text(LocalizedStringKey(page.kicker)).textCase(.uppercase)
                    .font(.caption.weight(.bold))
                    .tracking(2.5)
                    .foregroundStyle(page.artwork.tint.key)
            }

            Text(LocalizedStringKey(page.title))
                .font(.system(.largeTitle, design: .serif).weight(.heavy))
                .foregroundStyle(Palette.bone)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 12)

            Text(LocalizedStringKey(page.body))
                .font(.callout)
                .foregroundStyle(Palette.boneMuted)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 10)

            Spacer(minLength: 8)
        }
        .padding(.horizontal, 28)
    }

    // MARK: - Bottom controls

    private var bottomControls: some View {
        VStack(spacing: 20) {
            DescentRail(count: pages.count, current: index, tint: pages[index].artwork.tint.key)

            Button {
                Haptics.tap(.medium)
                if isLast {
                    onFinish()
                } else {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) { index += 1 }
                }
            } label: {
                HStack(spacing: 8) {
                    Text(LocalizedStringKey(isLast ? "Enter the Gate" : "Descend"))
                    Image(systemName: isLast ? "flame.fill" : "chevron.down")
                        .font(.subheadline.weight(.bold))
                }
            }
            .buttonStyle(.ember)
        }
        .padding(.horizontal, 28)
        .padding(.top, 8)
        .padding(.bottom, 24)
    }
}

// MARK: - Gateway hero (the arch)

private struct GatewayHero: View {
    let page: OnboardingPage
    let animated: Bool
    @State private var glow = false

    var body: some View {
        ZStack {
            // Ambient glow behind the arch.
            Circle()
                .fill(Gradients.glow(page.artwork.tint.key))
                .frame(width: 300, height: 300)
                .scaleEffect(glow ? 1.06 : 0.92)
                .opacity(0.9)

            GeometryReader { geo in
                let w = min(geo.size.height * 0.72, 220)
                let h = geo.size.height
                ZStack {
                    // The archway, looking through into the realm.
                    ArtworkView(style: page.artwork, symbolScale: 0.46)
                        .frame(width: w, height: h)
                        .clipShape(ArchShape())
                        .overlay(
                            ArchShape().stroke(Gradients.gold, lineWidth: 2.5)
                        )
                        .overlay(
                            ArchShape()
                                .inset(by: 7)
                                .stroke(Palette.goldPale.opacity(0.35), lineWidth: 1)
                        )
                        .shadow(color: page.artwork.tint.key.opacity(0.5), radius: 26, y: 14)

                    // Keystone glyph at the apex of the arch.
                    keystone
                        .offset(y: -h / 2 + w * 0.06)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .onAppear {
            guard animated else { return }
            withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) { glow = true }
        }
    }

    private var keystone: some View {
        ZStack {
            Circle()
                .fill(Gradients.gold)
                .frame(width: 44, height: 44)
                .overlay(Circle().stroke(Palette.abyss.opacity(0.4), lineWidth: 1))
                .shadow(color: Palette.gold.opacity(0.6), radius: 10)
            Image(systemName: page.artwork.symbol)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Palette.abyss)
        }
    }
}

/// A Roman archway: vertical sides rising into a semicircular top.
private struct ArchShape: InsettableShape {
    var inset: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let r = rect.insetBy(dx: inset, dy: inset)
        let radius = r.width / 2
        var path = Path()
        path.move(to: CGPoint(x: r.minX, y: r.maxY))
        path.addLine(to: CGPoint(x: r.minX, y: r.minY + radius))
        path.addArc(
            center: CGPoint(x: r.midX, y: r.minY + radius),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: r.maxX, y: r.maxY))
        path.closeSubpath()
        return path
    }

    func inset(by amount: CGFloat) -> ArchShape {
        ArchShape(inset: inset + amount)
    }
}

// MARK: - Descent rail (custom progress)

private struct DescentRail: View {
    let count: Int
    let current: Int
    let tint: Color

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<count, id: \.self) { i in
                node(i)
                if i < count - 1 {
                    Rectangle()
                        .fill(i < current ? AnyShapeStyle(Gradients.ember) : AnyShapeStyle(Palette.ash))
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: current)
    }

    private func node(_ i: Int) -> some View {
        let isCurrent = i == current
        let isDone = i < current
        return ZStack {
            if isCurrent {
                Circle()
                    .fill(Gradients.glow(tint))
                    .frame(width: 30, height: 30)
            }
            Diamond()
                .fill(isCurrent || isDone ? AnyShapeStyle(Gradients.ember) : AnyShapeStyle(Palette.ash))
                .frame(width: isCurrent ? 14 : 9, height: isCurrent ? 14 : 9)
                .overlay(
                    Diamond().stroke(Palette.goldPale.opacity(isCurrent ? 0.7 : 0), lineWidth: 1)
                )
        }
        .frame(width: 30, height: 30)
    }
}

private struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        p.closeSubpath()
        return p
    }
}

#Preview {
    OnboardingView(onFinish: {})
}
