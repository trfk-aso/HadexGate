//
//  Artwork.swift
//  HadexGate
//
//  Every content entity carries an ArtworkStyle. ArtworkView renders a unique,
//  procedurally-composed thematic illustration for it — layered gradient, glow,
//  a stylised sigil (SF Symbol, never an emoji) and seeded decorative geometry.
//
//  If a real image asset with the entity's `imageName` exists in the catalogue
//  it is used instead, so a designer can drop finished art in later without any
//  code changes.  Until then the procedural art guarantees 100% unique, on-theme
//  visuals with no missing-asset grey boxes.
//

import SwiftUI

enum ArtworkTint: String, Codable {
    case ember, gold, blood, river, spirit, shadow

    var gradient: LinearGradient {
        switch self {
        case .ember: return Gradients.ember
        case .gold: return Gradients.gold
        case .blood: return Gradients.blood
        case .river: return Gradients.river
        case .spirit: return Gradients.spirit
        case .shadow: return Gradients.card
        }
    }

    var key: Color {
        switch self {
        case .ember: return Palette.ember
        case .gold: return Palette.gold
        case .blood: return Palette.crimson
        case .river: return Palette.styx
        case .spirit: return Palette.violet
        case .shadow: return Palette.smoke
        }
    }
}

struct ArtworkStyle: Codable, Hashable {
    /// SF Symbol used as the central sigil.
    var symbol: String
    var tint: ArtworkTint
    /// Deterministic seed so decoration is stable but unique per entity.
    var seed: Int
    /// Optional real asset name; used automatically if present in the catalogue.
    var imageName: String?

    init(symbol: String, tint: ArtworkTint, seed: Int, imageName: String? = nil) {
        self.symbol = symbol
        self.tint = tint
        self.seed = seed
        self.imageName = imageName
    }
}

struct ArtworkView: View {
    let style: ArtworkStyle
    var symbolScale: CGFloat = 0.42

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            ZStack {
                style.tint.gradient

                // Deep vignette for depth.
                RadialGradient(
                    colors: [.clear, Palette.abyss.opacity(0.65)],
                    center: .center,
                    startRadius: side * 0.2,
                    endRadius: side * 0.85
                )

                SeededDecoration(seed: style.seed, tint: style.tint.key)

                // Central glow behind the sigil.
                Circle()
                    .fill(Gradients.glow(.white.opacity(0.5)))
                    .frame(width: side * 0.9, height: side * 0.9)
                    .blendMode(.plusLighter)
                    .opacity(0.5)

                Image(systemName: style.symbol)
                    .font(.system(size: side * symbolScale, weight: .light))
                    .foregroundStyle(.white.opacity(0.92))
                    .shadow(color: Palette.abyss.opacity(0.6), radius: 8, y: 4)
                    .symbolRenderingMode(.hierarchical)
            }
            .overlay(
                Rectangle()
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
        }
        .overlay(realAssetIfAvailable)
        .clipped()
        .accessibilityHidden(true)
    }

    /// Prefer a real catalogue image when the designer supplies one.
    @ViewBuilder
    private var realAssetIfAvailable: some View {
        if let name = style.imageName, UIImage(named: name) != nil {
            Image(name)
                .resizable()
                .scaledToFill()
        }
    }
}

/// Seeded geometric ornament — arcs, rays and sparks unique to each entity.
private struct SeededDecoration: View {
    let seed: Int
    let tint: Color

    var body: some View {
        Canvas { context, size in
            var rng = SplitMix64(seed: UInt64(bitPattern: Int64(seed &* 2654435761)))
            let w = size.width
            let h = size.height
            let center = CGPoint(x: w / 2, y: h / 2)

            // Concentric arcs.
            let arcs = 3 + Int(rng.next() % 3)
            for i in 0..<arcs {
                let r = w * (0.28 + 0.12 * Double(i))
                var path = Path()
                let start = Angle.degrees(rng.unit() * 360)
                path.addArc(center: center, radius: r,
                            startAngle: start,
                            endAngle: start + .degrees(120 + rng.unit() * 160),
                            clockwise: false)
                context.stroke(path, with: .color(.white.opacity(0.10)), lineWidth: 1.2)
            }

            // Radiating rays.
            let rays = 8 + Int(rng.next() % 10)
            for _ in 0..<rays {
                let angle = rng.unit() * 2 * .pi
                let inner = w * 0.12
                let outer = w * (0.4 + rng.unit() * 0.28)
                var path = Path()
                path.move(to: CGPoint(x: center.x + cos(angle) * inner,
                                      y: center.y + sin(angle) * inner))
                path.addLine(to: CGPoint(x: center.x + cos(angle) * outer,
                                         y: center.y + sin(angle) * outer))
                context.stroke(path, with: .color(tint.opacity(0.18)), lineWidth: 1)
            }

            // Sparks.
            let sparks = 14 + Int(rng.next() % 16)
            for _ in 0..<sparks {
                let x = rng.unit() * w
                let y = rng.unit() * h
                let s = 1 + rng.unit() * 2.5
                let rect = CGRect(x: x, y: y, width: s, height: s)
                context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(0.12 + rng.unit() * 0.2)))
            }
        }
        .blendMode(.plusLighter)
    }
}

/// Small deterministic PRNG so artwork is stable across launches.
private struct SplitMix64 {
    var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 0x9E3779B97F4A7C15 : seed }

    mutating func next() -> UInt64 {
        state = state &+ 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }

    mutating func unit() -> Double {
        Double(next() >> 11) * (1.0 / 9007199254740992.0)
    }
}
