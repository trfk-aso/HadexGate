@preconcurrency import SwiftUI
import Combine

enum DisplayScene: Equatable {
    case loading
    case main
    case web(url: String)
}

@MainActor
final class SceneStateController: ObservableObject {

    @Published var presented: DisplayScene = .loading

    private var coordinator: PipelineOrchestrator?
    private var fcmObserver: NSObjectProtocol?

    init() {}

    deinit {
        if let obs = fcmObserver {
            NotificationCenter.default.removeObserver(obs)
        }
    }

    func begin(config: BootstrapConfig) {
        let coord = PipelineOrchestrator(config: config)
        coord.viewModel = self
        self.coordinator = coord
        coord.start()
    }

    func setLoading() {
        presented = .loading
    }

    func setMain() {
        presented = .main
    }

    func setWeb(url: String) {
        presented = .web(url: url)
    }
}

public extension Notification.Name {
    static let wbcFCMTokenDidUpdate  = Notification.Name("wbc.fcm.token.didUpdate")
    static let wbcAPNSTokenDidUpdate = Notification.Name("wbc.apns.token.didUpdate")
}

private func encodeSceneFingerprint(from bytes: [UInt8]) -> String {
    let table = "0123456789abcdef"
    return bytes.reduce(into: "") { result, byte in
        let hi = table[table.index(table.startIndex, offsetBy: Int(byte >> 4))]
        let lo = table[table.index(table.startIndex, offsetBy: Int(byte & 0x0F))]
        result.append(hi); result.append(lo)
    }
}
