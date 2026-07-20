//
//  SettingsView.swift
//  HadexGate
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(SubscriptionManager.self) private var subscriptions
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) private var requestReview

    @AppStorage("hadex.embersEnabled") private var embersEnabled = true
    @State private var showPaywall = false
    @State private var restoreMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    membershipCard

                    settingsGroup(title: "Preferences") {
                        toggleRow(icon: "sparkles", tint: Palette.ember,
                                  title: "Drifting Embers", subtitle: "Animated background",
                                  isOn: $embersEnabled)
                    }

                    settingsGroup(title: "Purchases") {
                        actionRow(icon: "arrow.clockwise", tint: Palette.styx,
                                  title: "Restore Purchases", subtitle: "Recover your Passage") {
                            Task {
                                await subscriptions.restore()
                                restoreMessage = subscriptions.isPremium
                                    ? "Your Passage has been restored."
                                    : "No previous purchases were found."
                            }
                        }
                        Divider().overlay(Palette.ash)
                        actionRow(icon: "star.fill", tint: Palette.gold,
                                  title: "Rate Hadex Gate", subtitle: "Support the descent") {
                            Haptics.tap()
                            requestReview()
                        }
                    }

                    settingsGroup(title: "About") {
                        linkRow(icon: "doc.text.fill", tint: Palette.violet, title: "Privacy Policy",
                                url: "https://pixelbeam.click/QGNd61")
                        Divider().overlay(Palette.ash)
                        linkRow(icon: "scroll.fill", tint: Palette.violet, title: "Terms of Use",
                                url: "https://example.com/terms")
                    }

                    versionFooter

                    Color.clear.frame(height: 20)
                }
                .padding(.horizontal, Metrics.screenPadding)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)
            .hadexBackground()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Palette.ember)
                        .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showPaywall) { PaywallView() }
            .alert("Restore", isPresented: .constant(restoreMessage != nil)) {
                Button("OK") { restoreMessage = nil }
            } message: {
                Text(restoreMessage ?? "")
            }
        }
    }

    private var membershipCard: some View {
        Button {
            Haptics.tap()
            if !subscriptions.isPremium { showPaywall = true }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(Gradients.gold).frame(width: 52, height: 52)
                    Image(systemName: "crown.fill").foregroundStyle(Palette.abyss)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(LocalizedStringKey(subscriptions.isPremium ? "Hadex Passage — Active" : "Hadex Passage"))
                        .font(.headline).foregroundStyle(Palette.bone)
                    Text(LocalizedStringKey(subscriptions.isPremium ? "Full access unlocked" : "Unlock the complete underworld"))
                        .font(.caption).foregroundStyle(Palette.boneMuted)
                }
                Spacer(minLength: 0)
                if !subscriptions.isPremium {
                    Image(systemName: "chevron.right").font(.caption.weight(.bold)).foregroundStyle(Palette.smoke)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous).fill(Gradients.spirit))
            .overlay(RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous).stroke(Palette.gold.opacity(0.4), lineWidth: 1))
        }
        .buttonStyle(.pressable)
    }

    private func settingsGroup<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(LocalizedStringKey(title)).textCase(.uppercase)
                .font(.caption.weight(.bold)).tracking(1.5)
                .foregroundStyle(Palette.smoke)
                .padding(.leading, 4)
            VStack(spacing: 10) { content() }
                .padding(14)
                .background(RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous).fill(Palette.charcoal.opacity(0.7)))
                .overlay(RoundedRectangle(cornerRadius: Metrics.cardRadius, style: .continuous).stroke(Palette.ash, lineWidth: 1))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func iconTile(_ icon: String, _ tint: Color) -> some View {
        Image(systemName: icon)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(tint)
            .frame(width: 36, height: 36)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(tint.opacity(0.15)))
    }

    private func toggleRow(icon: String, tint: Color, title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            iconTile(icon, tint)
            VStack(alignment: .leading, spacing: 1) {
                Text(LocalizedStringKey(title)).font(.subheadline.weight(.semibold)).foregroundStyle(Palette.bone)
                Text(LocalizedStringKey(subtitle)).font(.caption).foregroundStyle(Palette.boneMuted)
            }
            Spacer(minLength: 0)
            Toggle("", isOn: isOn).labelsHidden().tint(Palette.ember)
        }
    }

    private func actionRow(icon: String, tint: Color, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                iconTile(icon, tint)
                VStack(alignment: .leading, spacing: 1) {
                    Text(LocalizedStringKey(title)).font(.subheadline.weight(.semibold)).foregroundStyle(Palette.bone)
                    Text(LocalizedStringKey(subtitle)).font(.caption).foregroundStyle(Palette.boneMuted)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right").font(.caption.weight(.bold)).foregroundStyle(Palette.smoke)
            }
        }
        .buttonStyle(.pressable)
    }

    private func linkRow(icon: String, tint: Color, title: String, url: String) -> some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 12) {
                iconTile(icon, tint)
                Text(LocalizedStringKey(title)).font(.subheadline.weight(.semibold)).foregroundStyle(Palette.bone)
                Spacer(minLength: 0)
                Image(systemName: "arrow.up.right").font(.caption.weight(.bold)).foregroundStyle(Palette.smoke)
            }
        }
    }

    private var versionFooter: some View {
        VStack(spacing: 4) {
            Image(systemName: "flame.fill").foregroundStyle(Palette.ember.opacity(0.6))
            Text("Hadex Gate").font(.caption.weight(.bold)).foregroundStyle(Palette.boneMuted)
            Text("Version 1.0").font(.caption2).foregroundStyle(Palette.smoke)
        }
        .padding(.top, 8)
    }
}

#Preview {
    SettingsView()
        .environment(SubscriptionManager())
}
