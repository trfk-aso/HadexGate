//
//  RootView.swift
//  HadexGate
//
//  Owns the Onboarding ↔ MainContent decision (per ASO §5.8).
//

import SwiftUI

struct RootView: View {
    @AppStorage("hadex.hasOnboarded") private var hasOnboarded = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Group {
            if hasOnboarded {
                MainTabView()
                    .transition(.opacity)
            } else {
                OnboardingView {
                    withAnimation(reduceMotion ? .easeInOut(duration: 0.3)
                                                : .spring(response: 0.5, dampingFraction: 0.8)) {
                        hasOnboarded = true
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    RootView()
        .environment(SubscriptionManager())
        .environment(LibraryStore())
        .environment(OracleService())
}
