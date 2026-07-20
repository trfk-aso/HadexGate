//
//  HistoryRow.swift
//  HadexGate
//

import SwiftUI

struct HistoryRow: View {
    let event: HistoryEvent

    private var tint: Color {
        switch event.kind {
        case .viewed: return Palette.ember
        case .gate: return Palette.gold
        case .quiz: return Palette.crimson
        case .oracle: return Palette.violet
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: event.kind.symbol)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(tint.opacity(0.15))
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(LocalizedStringKey(event.title))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Palette.bone)
                    .lineLimit(1)
                Text(LocalizedStringKey(event.detail))
                    .font(.caption)
                    .foregroundStyle(Palette.boneMuted)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
            VStack(alignment: .trailing, spacing: 2) {
                Text(LocalizedStringKey(event.kind.label))
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(tint)
                Text(event.date, format: .relative(presentation: .named))
                    .font(.caption2)
                    .foregroundStyle(Palette.smoke)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Palette.charcoal.opacity(0.7))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Palette.ash, lineWidth: 1)
        )
    }
}
