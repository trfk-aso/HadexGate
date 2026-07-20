//
//  ReviewManager.swift
//  HadexGate
//
//  Counts app launches and decides when to ask for an App Store rating.
//  Created once at @main and injected via the environment.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class ReviewManager {
    private let defaults = UserDefaults.standard
    private let launchCountKey = "hadex.launchCount"
    private let reviewRequestedKey = "hadex.reviewRequested"

    /// How many times the app has been launched (this launch included).
    let launchCount: Int

    init() {
        // Runs exactly once per process launch (owned as @State at @main).
        let newCount = defaults.integer(forKey: launchCountKey) + 1
        defaults.set(newCount, forKey: launchCountKey)
        launchCount = newCount
    }

    /// Ask for a rating on the SECOND launch, one time only.
    var shouldRequestReview: Bool {
        launchCount >= 2 && !defaults.bool(forKey: reviewRequestedKey)
    }

    func markReviewRequested() {
        defaults.set(true, forKey: reviewRequestedKey)
    }
}
