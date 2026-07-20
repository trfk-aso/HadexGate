//
//  GateResultView.swift
//  HadexGate
//
//  Result screen for the Gate test: verdict artwork, three+ output parameters,
//  narrative, traits, share, and retake.
//

import SwiftUI

struct GateResultView: View {
    let verdict: GateVerdict
    let onRetake: () -> Void

    @State private var appeared = false

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                hero

                parameters

                summaryBlock

                traitsBlock

                actions

                Color.clear.frame(height: 96)
            }
            .padding(.horizontal, Metrics.screenPadding)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .hadexBackground()
        .navigationTitle("The Verdict")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) { appeared = true }
        }
    }

    private var hero: some View {
        VStack(spacing: 14) {
            ArtworkView(style: verdict.artwork, symbolScale: 0.42)
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(verdict.tint.opacity(0.6), lineWidth: 1)
                )
                .shadow(color: verdict.tint.opacity(0.5), radius: 30, y: 12)
                .scaleEffect(appeared ? 1 : 0.8)
                .rotation3DEffect(.degrees(appeared ? 0 : 12), axis: (x: 1, y: 0, z: 0))

            Text("THE JUDGES DECREE")
                .font(.caption.weight(.bold))
                .tracking(3)
                .foregroundStyle(verdict.tint)
            Text(LocalizedStringKey(verdict.title))
                .font(.system(.largeTitle, design: .serif).weight(.heavy))
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.bone)
            Text(LocalizedStringKey(verdict.verdictLine))
                .font(.callout.italic())
                .multilineTextAlignment(.center)
                .foregroundStyle(Palette.boneMuted)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var parameters: some View {
        SurfaceCard(tint: verdict.tint) {
            VStack(spacing: 6) {
                ParameterRow(icon: "mappin.and.ellipse", label: "Destination",
                             value: verdict.shortName, tint: verdict.tint)
                Divider().overlay(Palette.ash)
                ParameterRow(icon: "person.fill.checkmark", label: "Your nature",
                             value: verdict.traits.first ?? "—", tint: verdict.tint)
                Divider().overlay(Palette.ash)
                ParameterRow(icon: "scalemass.fill", label: "Judged by",
                             value: "Minos, Rhadamanthus & Aeacus", tint: verdict.tint)
            }
        }
    }

    private var summaryBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "What awaits you", systemImage: verdict.symbol)
            Text(LocalizedStringKey(verdict.summary))
                .font(.callout)
                .foregroundStyle(Palette.boneMuted)
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                .fill(Palette.charcoal.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous)
                .stroke(Palette.ash, lineWidth: 1)
        )
    }

    private var traitsBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Why the gate chose this", systemImage: "sparkles")
            FlowLayout(spacing: 8) {
                ForEach(verdict.traits, id: \.self) { trait in
                    TagPill(text: trait, systemImage: "checkmark", tint: verdict.tint)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var actions: some View {
        VStack(spacing: 12) {
            ShareLink(item: shareText) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Your Fate")
                }
                .font(.headline)
                .foregroundStyle(Palette.abyss)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Gradients.ember))
            }

            Button {
                Haptics.tap()
                onRetake()
            } label: {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Take the Test Again")
                }
                .font(.headline)
                .foregroundStyle(Palette.bone)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Palette.slate))
                .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Palette.ash, lineWidth: 1))
            }
            .buttonStyle(.pressable)
        }
    }

    private var shareText: String {
        "The judges of Hades sent my soul to \(verdict.shortName) — \(verdict.title).\n\nWhere would you go? Find out in Hadex Gate."
    }
}

#Preview {
    NavigationStack {
        GateResultView(verdict: .elysium, onRetake: {})
    }
}
