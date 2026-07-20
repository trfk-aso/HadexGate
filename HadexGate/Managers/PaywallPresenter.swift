//
//  PaywallPresenter.swift
//  HadexGate
//
//  A tiny app-level coordinator so the paywall is presented ONCE, above the whole
//  tab UI — decoupled from any NavigationStack (where a sheet's tap could be
//  swallowed by navigation).
//

import Observation

@MainActor
@Observable
final class PaywallPresenter {
    var isPresented = false

    func present() {
        isPresented = true
    }
}
