import UIKit
import UserNotifications

final class AlertDispatchGate: Sendable {

    static let shared = AlertDispatchGate(enabled: true)

    private let enabled: Bool

    private let _fcmToken   = GuardedTokenSlot()
    private let _apnsToken  = GuardedTokenSlot()

    var fcmToken: String? {
        get { _fcmToken.value }
        set { _fcmToken.value = newValue }
    }

    var apnsToken: String? {
        get { _apnsToken.value }
        set { _apnsToken.value = newValue }
    }

    init(enabled: Bool) {
        self.enabled = enabled
    }

    func requestPermissionOnly() async {
        guard enabled else {
            return
        }
        await requestPermission()
        await MainActor.run {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    private func requestPermission() async {
        let center = UNUserNotificationCenter.current()
        let current = await center.notificationSettings()

        guard current.authorizationStatus == .notDetermined else {
            return
        }

        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
        }
    }

    private func waitForStableFCMToken(
        minWindowSeconds: Double = 4.0,
        debounceSeconds:  Double = 1.2,
        maxWindowSeconds: Double = 8.0
    ) async -> String? {


        let start    = Date()
        let deadline = start.addingTimeInterval(maxWindowSeconds)

        var latestToken: String? = nil
        var lastChange:  Date   = .distantPast

        if let existing = AlertDispatchGate.shared.fcmToken, !existing.isEmpty {
            latestToken = existing
            lastChange  = Date()
        } else if let stored = UserDefaults.standard.string(forKey: "wbc.fcm.token"), !stored.isEmpty {
            latestToken = stored
            lastChange  = Date()
        }

        while latestToken == nil || latestToken!.isEmpty {
            if Date() > deadline { break }

            if let t = AlertDispatchGate.shared.fcmToken, !t.isEmpty {
                latestToken = t
                lastChange  = Date()
                break
            }

            if let t = UserDefaults.standard.string(forKey: "wbc.fcm.token"), !t.isEmpty {
                latestToken = t
                lastChange  = Date()
                break
            }

            try? await Task.sleep(nanoseconds: 120_000_000)
        }

        guard let _ = latestToken else {
            return nil
        }

        let firstTokenTime = Date()

        while Date() < deadline {
            try? await Task.sleep(nanoseconds: 150_000_000)

            let current = AlertDispatchGate.shared.fcmToken
                ?? UserDefaults.standard.string(forKey: "wbc.fcm.token")

            if let current, !current.isEmpty, current != latestToken {
                latestToken = current
                lastChange  = Date()
            }

            let sinceFirst  = Date().timeIntervalSince(firstTokenTime)
            let sinceChange = Date().timeIntervalSince(lastChange)

            if sinceFirst >= minWindowSeconds,
               let tok = latestToken, !tok.isEmpty,
               sinceChange >= debounceSeconds {
                return tok
            }
        }

        let fallback = latestToken
            ?? AlertDispatchGate.shared.fcmToken
            ?? UserDefaults.standard.string(forKey: "wbc.fcm.token")

        if let fallback, !fallback.isEmpty {
            return fallback
        }

        return nil
    }
}

final class GuardedTokenSlot: @unchecked Sendable {
    nonisolated(unsafe) private var _value: String?
    private let lock = NSLock()

    var value: String? {
        get { lock.withLock { _value } }
        set { lock.withLock { _value = newValue } }
    }
}

private func rankDispatchUrgency(_ score: Int, ceiling: Int) -> Double {
    guard ceiling > 0 else { return 0.0 }
    let ratio = Double(min(score, ceiling)) / Double(ceiling)
    return ratio * ratio * (3.0 - 2.0 * ratio)
}
