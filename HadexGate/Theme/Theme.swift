//
//  Theme.swift
//  HadexGate
//
//  Single source of truth for the app's colour system.
//  The concept: an ember-lit descent into the Greek underworld —
//  charcoal blacks, molten orange, ash-gold and bone white.
//

import SwiftUI

enum Palette {
    // Base — the darkness of the underworld
    static let abyss = Color(hex: "#07060A")      // deepest background
    static let obsidian = Color(hex: "#0E0B12")   // primary background
    static let charcoal = Color(hex: "#161119")   // raised surface
    static let slate = Color(hex: "#221A2B")      // card surface
    static let ash = Color(hex: "#2E2536")        // stroke / divider

    // Ember — the fire of the gates
    static let ember = Color(hex: "#FF6B1A")      // primary orange
    static let emberDeep = Color(hex: "#E24E0B")  // deep orange
    static let emberBright = Color(hex: "#FF8A3D")

    // Gold — judgment & glory
    static let gold = Color(hex: "#F5A623")
    static let goldPale = Color(hex: "#FFCE73")

    // Blood — Tartarus & danger
    static let blood = Color(hex: "#B0202E")
    static let crimson = Color(hex: "#D93A47")

    // Cool depths — the rivers of the dead
    static let styx = Color(hex: "#3E6E7A")
    static let styxDeep = Color(hex: "#24454E")
    static let violet = Color(hex: "#6E4A8E")     // spirit / soul accent

    // Bone — text
    static let bone = Color(hex: "#F6EFE6")       // primary text (warm white)
    static let boneMuted = Color(hex: "#B5A9B8")  // secondary text
    static let smoke = Color(hex: "#7C7285")      // tertiary text
}

extension ShapeStyle where Self == Color {
    static var appBone: Color { Palette.bone }
    static var appEmber: Color { Palette.ember }
}

enum Gradients {
    /// The main app background — a slow burn from black up into ember dark.
    static let background = LinearGradient(
        colors: [Palette.abyss, Palette.obsidian, Color(hex: "#160C10")],
        startPoint: .top,
        endPoint: .bottom
    )

    static let ember = LinearGradient(
        colors: [Palette.emberBright, Palette.ember, Palette.emberDeep],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let gold = LinearGradient(
        colors: [Palette.goldPale, Palette.gold, Palette.emberDeep],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let blood = LinearGradient(
        colors: [Palette.crimson, Palette.blood, Color(hex: "#5E1119")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let river = LinearGradient(
        colors: [Palette.styx, Palette.styxDeep, Palette.violet],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let spirit = LinearGradient(
        colors: [Palette.violet, Color(hex: "#3B2A54"), Palette.charcoal],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let card = LinearGradient(
        colors: [Palette.slate, Palette.charcoal],
        startPoint: .top,
        endPoint: .bottom
    )

    /// A subtle glow used behind featured artwork.
    static func glow(_ color: Color) -> RadialGradient {
        RadialGradient(
            colors: [color.opacity(0.55), color.opacity(0.0)],
            center: .center,
            startRadius: 2,
            endRadius: 240
        )
    }
}

enum Metrics {
    static let cardRadius: CGFloat = 22
    static let tileRadius: CGFloat = 18
    static let screenPadding: CGFloat = 20
}
