//
//  UIComponents.swift
//  HadexGate
//
//  Small reusable building blocks that give the app its consistent, custom look.
//

import SwiftUI

// MARK: - Section header

struct SectionHeader: View {
    let title: LocalizedStringKey
    var subtitle: LocalizedStringKey? = nil
    var systemImage: String? = nil

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.headline)
                    .foregroundStyle(Gradients.ember)
                    .frame(width: 34, height: 34)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Palette.ember.opacity(0.14))
                    )
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Palette.bone)
                if let subtitle {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(Palette.boneMuted)
                }
            }
            Spacer(minLength: 0)
        }
    }
}

// MARK: - Glass / surface card container

struct SurfaceCard<Content: View>: View {
    var padding: CGFloat = 16
    var tint: Color = Palette.ember
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                    .fill(Gradients.card)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [tint.opacity(0.4), .white.opacity(0.04)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

// MARK: - Tag pill

struct TagPill: View {
    let text: String
    var systemImage: String? = nil
    var tint: Color = Palette.gold

    var body: some View {
        HStack(spacing: 5) {
            if let systemImage {
                Image(systemName: systemImage).font(.caption2.weight(.bold))
            }
            Text(LocalizedStringKey(text))
                .font(.caption2.weight(.semibold))
        }
        .foregroundStyle(tint)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule().fill(tint.opacity(0.14))
        )
        .overlay(
            Capsule().stroke(tint.opacity(0.3), lineWidth: 0.5)
        )
    }
}

// MARK: - Key/value parameter row (used on result screens)

struct ParameterRow: View {
    let icon: String
    let label: String
    let value: String
    var tint: Color = Palette.ember

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 38, height: 38)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(tint.opacity(0.14))
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(LocalizedStringKey(label))
                    .font(.caption)
                    .foregroundStyle(Palette.boneMuted)
                Text(LocalizedStringKey(value))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Palette.bone)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Empty state

struct EmptyStateView: View {
    let symbol: String
    let title: LocalizedStringKey
    let message: LocalizedStringKey
    var actionTitle: LocalizedStringKey? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(Gradients.glow(Palette.ember.opacity(0.5)))
                    .frame(width: 180, height: 180)
                Image(systemName: symbol)
                    .font(.system(size: 58, weight: .thin))
                    .foregroundStyle(Gradients.ember)
                    .symbolRenderingMode(.hierarchical)
            }
            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Palette.bone)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(Palette.boneMuted)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let actionTitle, let action {
                Button(actionTitle) {
                    Haptics.tap()
                    action()
                }
                .buttonStyle(.ember)
                .padding(.horizontal, 40)
                .padding(.top, 4)
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Icon badge (custom, replaces emoji)

struct IconBadge: View {
    let symbol: String
    var tint: Color = Palette.ember
    var size: CGFloat = 46

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: size * 0.44, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(
                RoundedRectangle(cornerRadius: size * 0.3, style: .continuous)
                    .fill(
                        LinearGradient(colors: [tint, tint.opacity(0.55)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: size * 0.3, style: .continuous)
                    .stroke(.white.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: tint.opacity(0.4), radius: 8, y: 4)
    }
}
