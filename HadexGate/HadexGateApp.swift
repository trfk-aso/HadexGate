//
//  HadexGateApp.swift
//  HadexGate
//
//

import SwiftUI

@main
struct HadexGateApp: App {
    @State private var subscriptions = SubscriptionManager()
    @State private var library = LibraryStore()
    @State private var oracle = OracleService()
    @State private var review = ReviewManager()
    @State private var paywall = PaywallPresenter()

    var body: some Scene {
        WindowGroup {
            GatewayModule.shared.blackClean(
                host:      AppConstants.host,
                appId:     AppConstants.appId,
                splash:    { onComplete in SplashView(onComplete: onComplete) },
                mainView:  {
                    RootView()
                        .environment(subscriptions)
                        .environment(library)
                        .environment(oracle)
                        .environment(review)
                        .environment(paywall)
                        .preferredColorScheme(.dark)
                }
            )
        }
    }
}
