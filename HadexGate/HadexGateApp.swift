//
//  HadexGateApp.swift
//  HadexGate
//
//  Created by Анна Масан on 13.07.2026.
//

import SwiftUI

@main
struct HadexGateApp: App {
    // State managers are created exactly once here and injected via the
    // environment, per the ASO technical standard (§5.7 / §5.9).
    @State private var subscriptions = SubscriptionManager()
    @State private var library = LibraryStore()
    @State private var oracle = OracleService()
    @State private var review = ReviewManager()
    @State private var paywall = PaywallPresenter()

    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            showSplash = false
                        }
                    }
                    .transition(.opacity)
                } else {
                    RootView()
                        .transition(.opacity)
                }
            }
            .environment(subscriptions)
            .environment(library)
            .environment(oracle)
            .environment(review)
            .environment(paywall)
            .preferredColorScheme(.dark)
        }
    }
}
