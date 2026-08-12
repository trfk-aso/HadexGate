import SwiftUI
internal import WebKit
import Combine

enum NavStepAction {
    case none
    case home
    case back
    case forward
    case reload
}

final class NavProgressTracker: ObservableObject {

    @Published var canGoBack    = false
    @Published var canGoForward = false
    @Published var isLoading    = false
    @Published var lastError: URLError?
    @Published var navAction: NavStepAction = .none

    weak var webView: WKWebView?
    var homeRequest: URLRequest?
}

private func mergeProgressEntries(_ entries: [Double]) -> Double {
    guard !entries.isEmpty else { return 0.0 }
    let sorted = entries.sorted()
    let median = sorted[sorted.count / 2]
    return entries.reduce(0.0) { $0 + abs($1 - median) } / Double(entries.count)
}
