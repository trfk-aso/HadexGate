//
//  MainTabView.swift
//  HadexGate
//
//  The main content shell: five destinations behind a custom, animated tab bar.
//

import SwiftUI

enum AppTab: Int, CaseIterable, Identifiable {
    case home, explore, trials, oracle, library
    var id: Int { rawValue }

    var title: String {
        switch self {
        case .home: return "Gate"
        case .explore: return "Explore"
        case .trials: return "Trials"
        case .oracle: return "Oracle"
        case .library: return "Library"
        }
    }

    var symbol: String {
        switch self {
        case .home: return "flame.fill"
        case .explore: return "books.vertical.fill"
        case .trials: return "door.left.hand.open"
        case .oracle: return "sparkles"
        case .library: return "bookmark.fill"
        }
    }
}

struct MainTabView: View {
    @State private var selection: AppTab = .home
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(PaywallPresenter.self) private var paywall
    @State private var showPaywall = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selection {
                case .home: DashboardView(selection: $selection)
                case .explore: ExploreView()
                case .trials: TrialsView()
                case .oracle: OracleView()
                case .library: LibraryView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            HadexTabBar(selection: $selection)
                // The bar stays pinned when the keyboard opens; screen content
                // (e.g. the Oracle input) is free to rise above the keyboard.
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        // Presented once, above the whole tab UI — never inside a NavigationStack.
        // Bridged to a local @State so the change is always observed and presented.
        .sheet(isPresented: $showPaywall) { PaywallView() }
        .onChange(of: paywall.isPresented) { _, present in
            if present {
                showPaywall = true
                paywall.isPresented = false   // edge-triggered
            }
        }
    }
}

private struct HadexTabBar: View {
    @Binding var selection: AppTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                tabButton(tab)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(
                    LinearGradient(colors: [Palette.ember.opacity(0.4), .white.opacity(0.05)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 1
                )
        )
        .shadow(color: Palette.abyss.opacity(0.6), radius: 18, y: 8)
        .padding(.horizontal, 18)
        .padding(.bottom, 6)
    }

    private func tabButton(_ tab: AppTab) -> some View {
        let isSelected = selection == tab
        return Button {
            Haptics.tap()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selection = tab
            }
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Gradients.ember)
                            .frame(width: 46, height: 34)
                            .shadow(color: Palette.ember.opacity(0.5), radius: 8, y: 3)
                            .matchedGeometryEffect(id: "tabHighlight", in: namespace)
                    }
                    Image(systemName: tab.symbol)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(isSelected ? Palette.abyss : Palette.smoke)
                }
                .frame(height: 34)

                Text(LocalizedStringKey(tab.title))
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(isSelected ? Palette.ember : Palette.smoke)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : .isButton)
    }

    @Namespace private var namespace
}

#Preview {
    MainTabView()
        .environment(SubscriptionManager())
        .environment(LibraryStore())
        .environment(OracleService())
}
