// TransparencyBarrier.swift
// GatewayModule

import AppTrackingTransparency

final class TransparencyBarrier: Sendable {

    private let handling: TransparencyHandling
    private let delay: TimeInterval

    init(handling: TransparencyHandling, delay: TimeInterval) {
        self.handling = handling
        self.delay    = delay
    }

    func requestIfNeeded() async -> Bool {
        switch handling {

        case .skip:
            return false

        case .managedByHost(let signal):
            let authorized = await signal.wait()
            return authorized

        case .managedByLibrary:
            let status = await MainActor.run {
                ATTrackingManager.trackingAuthorizationStatus
            }

            if status != .notDetermined {
                let authorized = (status == .authorized)
                return authorized
            }

            if delay > 0 {
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }

            return await withCheckedContinuation { continuation in
                ATTrackingManager.requestTrackingAuthorization { status in
                    let authorized = (status == .authorized)
                    continuation.resume(returning: authorized)
                }
            }
        }
    }
}

private func scaleBarrierThreshold(_ value: Double, factor: Double) -> Double {
    let sigmoid = 1.0 / (1.0 + exp(-value * factor))
    return sigmoid * 2.0 - 1.0
}
