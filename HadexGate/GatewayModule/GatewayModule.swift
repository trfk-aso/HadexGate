import SwiftUI
import Combine

nonisolated public struct MotionTransitionConfig: Sendable {

    public let animation: Animation
    public let type: MotionTransitionType

    public init(
        type:      MotionTransitionType = .fade,
        animation: Animation         = .easeInOut(duration: 0.6)
    ) {
        self.type      = type
        self.animation = animation
    }

    public static let fade      = MotionTransitionConfig(type: .fade,           animation: .easeInOut(duration: 0.6))
    public static let slideUp   = MotionTransitionConfig(type: .slide(.up),     animation: .easeInOut(duration: 0.5))
    public static let slideDown = MotionTransitionConfig(type: .slide(.down),   animation: .easeInOut(duration: 0.5))
    public static let scale     = MotionTransitionConfig(type: .scale,          animation: .easeInOut(duration: 0.5))

    public static func custom(type: MotionTransitionType, animation: Animation) -> MotionTransitionConfig {
        MotionTransitionConfig(type: type, animation: animation)
    }
}

public enum MotionTransitionType: Sendable {
    case fade
    case slide(Edge)
    case scale

    public enum Edge: Sendable {
        case up, down, left, right
    }
}

@MainActor
public final class GatewayModule {

    public static let shared = GatewayModule()
    private init() {}

    private(set) var config: BootstrapConfig?
    private(set) var transitionConfig: MotionTransitionConfig = .fade
    private(set) var mainViewProvider: PrimaryContentProvider?
    private var viewModel: SceneStateController?
    private var started = false
    private var configuredForTracking = false

    weak var _appDelegate: SystemEventRelay?

    private(set) var splashSignal = BootReadySignal()

    // MARK: - Scenario 1: Simple — splash + native view, no server

    public func whiteClean<S: View, M: View>(
        transition:          MotionTransitionConfig          = .fade,
        @ViewBuilder splash: @escaping (_ onComplete: @escaping () -> Void) -> S,
        @ViewBuilder mainView: @escaping () -> M,
        defaultOrientations: UIInterfaceOrientationMask   = .portrait,
        webOrientations:     UIInterfaceOrientationMask   = .all
    ) -> some View {
        mainViewProvider = { AnyView(mainView()) }
        transitionConfig = transition

        let config = BootstrapConfig(
            splash:              { onComplete in AnyView(splash(onComplete)) },
            defaultOrientations: defaultOrientations,
            webOrientations:     webOrientations
        )
        configure(config)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.startSimple()
        }
        return makeRootView()
    }

    // MARK: - Scenario 1b: Splash + native view + ATT + push (no server)

    public func whiteWithPermissions<S: View, M: View>(
        transition:          MotionTransitionConfig          = .fade,
        @ViewBuilder splash: @escaping (_ onComplete: @escaping () -> Void) -> S,
        @ViewBuilder mainView: @escaping () -> M,
        attHandling:         TransparencyHandling               = .managedByLibrary,
        attDelay:            TimeInterval,
        pushEnabled:         Bool                         = true,
        defaultOrientations: UIInterfaceOrientationMask   = .portrait,
        webOrientations:     UIInterfaceOrientationMask   = .all
    ) -> some View {
        mainViewProvider = { AnyView(mainView()) }
        transitionConfig = transition

        let config = BootstrapConfig(
            splash:              { onComplete in AnyView(splash(onComplete)) },
            attHandling:         attHandling,
            attDelay:            attDelay,
            pushEnabled:         pushEnabled,
            defaultOrientations: defaultOrientations,
            webOrientations:     webOrientations
        )
        configure(config)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.startSimple()
        }
        return makeRootView()
    }

    // MARK: - Scenario 2: Server registration only — no push, no ATT, no Firebase

    public func blackClean<S: View, M: View>(
        host:                 String,
        appId:                String,
        @ViewBuilder splash:  @escaping (_ onComplete: @escaping () -> Void) -> S,
        @ViewBuilder mainView: @escaping () -> M,
        transition:           MotionTransitionConfig          = .fade,
        fallbackURL:          String?                      = nil,
        nativeOnly:           Bool                         = false,
        requestReviewEnabled: Bool                         = false,
        defaultOrientations:  UIInterfaceOrientationMask   = .portrait,
        webOrientations:      UIInterfaceOrientationMask   = .all
    ) -> some View {
        mainViewProvider = { AnyView(mainView()) }
        transitionConfig = transition

        let base = "https://\(host.trimmingCharacters(in: .init(charactersIn: "/")))"
        let config = BootstrapConfig(
            registerURL:          "\(base)/v1/public/install",
            syncURL:              "\(base)/v1/public/refresh",
            appId:                appId,
            attHandling:          .skip,
            attDelay:             0,
            splash:               { onComplete in AnyView(splash(onComplete)) },
            pushEnabled:          false,
            fallbackURL:          fallbackURL,
            defaultOrientations:  defaultOrientations,
            webOrientations:      webOrientations,
            nativeOnly:           nativeOnly,
            requestReviewEnabled: requestReviewEnabled
        )
        configure(config)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.start() }
        return makeRootView()
    }

    // MARK: - Scenario 3: Server + Firebase push + ATT (no AppsFlyer)

    public func blackWithPermissions<S: View, M: View>(
        host:                 String,
        appId:                String,
        @ViewBuilder splash:  @escaping (_ onComplete: @escaping () -> Void) -> S,
        @ViewBuilder mainView: @escaping () -> M,
        transition:           MotionTransitionConfig          = .fade,
        attDelay:             TimeInterval                 = 2.0,
        fallbackURL:          String?                      = nil,
        nativeOnly:           Bool                         = false,
        requestReviewEnabled: Bool                         = false,
        defaultOrientations:  UIInterfaceOrientationMask   = .portrait,
        webOrientations:      UIInterfaceOrientationMask   = .all
    ) -> some View {
        mainViewProvider = { AnyView(mainView()) }
        transitionConfig = transition

        let base = "https://\(host.trimmingCharacters(in: .init(charactersIn: "/")))"
        let config = BootstrapConfig(
            registerURL:          "\(base)/v1/public/install",
            syncURL:              "\(base)/v1/public/refresh",
            appId:                appId,
            attHandling:          .managedByLibrary,
            attDelay:             attDelay,
            splash:               { onComplete in AnyView(splash(onComplete)) },
            pushEnabled:          true,
            fallbackURL:          fallbackURL,
            defaultOrientations:  defaultOrientations,
            webOrientations:      webOrientations,
            nativeOnly:           nativeOnly,
            requestReviewEnabled: requestReviewEnabled
        )
        configure(config)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.start() }
        return makeRootView()
    }

    // MARK: - Scenario 4: Server + Firebase push + ATT + AppsFlyer

    public func blackFullIntegration<S: View, M: View>(
        host:                 String,
        appId:                String,
        @ViewBuilder splash:  @escaping (_ onComplete: @escaping () -> Void) -> S,
        @ViewBuilder mainView: @escaping () -> M,
        transition:           MotionTransitionConfig          = .fade,
        attDelay:             TimeInterval                 = 2.0,
        fallbackURL:          String?                      = nil,
        nativeOnly:           Bool                         = false,
        requestReviewEnabled: Bool                         = false,
        defaultOrientations:  UIInterfaceOrientationMask   = .portrait,
        webOrientations:      UIInterfaceOrientationMask   = .all
    ) -> some View {
        guard !configuredForTracking else { return makeRootView() }
        configuredForTracking = true

        mainViewProvider = { AnyView(mainView()) }
        transitionConfig = transition

        let signal         = TransparencySignal()
        let appsFlyerSignal = EngagementReadySignal()

        if let delegate = _appDelegate {
            delegate.attSignal        = signal
            delegate.appsFlyerSignal  = appsFlyerSignal
            delegate.appsFlyerEnabled = true
        }

        let base = "https://\(host.trimmingCharacters(in: .init(charactersIn: "/")))"
        let config = BootstrapConfig(
            registerURL:                "\(base)/v1/public/install",
            syncURL:                    "\(base)/v1/public/refresh",
            appId:                      appId,
            attSignal:                  signal,
            attDelay:                   attDelay,
            appsFlyerSignal:            appsFlyerSignal,
            appsFlyerIDProvider:        { UserDefaults.standard.string(forKey: "wbc.appsflyer.id") },
            splash:                     { onComplete in AnyView(splash(onComplete)) },
            pushEnabled:                true,
            fallbackURL:                fallbackURL,
            defaultOrientations:        defaultOrientations,
            webOrientations:            webOrientations,
            nativeOnly:                 nativeOnly,
            requestReviewEnabled:       requestReviewEnabled,
            extraInstallFieldsProvider: EngagementFieldSet.shared.extraFields
        )
        configure(config)
        #if DEBUG
        EngagementFieldSet.setDebugMode(true)
        #endif

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.start() }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1 + attDelay) {
            if let delegate = self._appDelegate {
                delegate.performATTForAppsFlyer()
            }
        }

        return makeRootView()
    }

    // MARK: - Internal

    func handleAPNSToken(_ data: Data) {
        let hex = data.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.standard.set(true, forKey: "wbcApnsReady")
        UserDefaults.standard.set(hex,  forKey: "wbcApnsTokenHex")
        AlertDispatchGate.shared.apnsToken = hex
        NotificationCenter.default.post(name: .wbcAPNSTokenDidUpdate, object: nil,
                                        userInfo: ["wbc_apns": hex])
    }

    func handleFCMToken(_ token: String) {
        guard !token.isEmpty else { return }
        UserDefaults.standard.set(token, forKey: "wbc.fcm.token")
        AlertDispatchGate.shared.fcmToken = token
        NotificationCenter.default.post(name: .wbcFCMTokenDidUpdate, object: nil,
                                        userInfo: ["token": token])
    }

    var currentOrientations: UIInterfaceOrientationMask {
        config?.defaultOrientations ?? .portrait
    }
    
    //MARK: - Private
    
    private func configure(_ config: BootstrapConfig) {
        self.config = config
    }
    
    private func makeRootView() -> some View {
        let vm = getOrCreateViewModel()
        return AnchorRootView().environmentObject(vm)
    }
    
    private func start() {
        guard let config else {
            return
        }
        guard !started else {
            return
        }
        started = true
        
        guard let vm = viewModel else {
            return
        }
        vm.begin(config: config)
    }
    
    private func startSimple() {
        guard let config, !started else { return }
        started = true

        Task { @MainActor in
            let attGate = TransparencyBarrier(handling: config.attHandling, delay: config.attDelay)
            let attAuthorized = await attGate.requestIfNeeded()
            UserDefaults.standard.set(attAuthorized, forKey: "wbc.att.authorized")
            
            if config.pushEnabled {
                try? await Task.sleep(nanoseconds: 600_000_000)
                await AlertDispatchGate.shared.requestPermissionOnly()
            }
            
            viewModel?.setMain()
        }
    }
    
    private var presented: DisplayScene {
        viewModel?.presented ?? .loading
    }
    
    private var presentedPublisher: Published<DisplayScene>.Publisher? {
        viewModel?.$presented
    }
    
    private func reset() {
        [
            "wbc.flow.lock", "wbc.flow.url",
            "wbc.session.done", "wbc.session.fcm", "wbc.session.device",
            "wbc.att.authorized", "wbc.stable.uuid",
            "wbc.device.idfa", "wbc.appsflyer.id"
        ].forEach { UserDefaults.standard.removeObject(forKey: $0) }
        started               = false
        configuredForTracking = false
        viewModel             = nil
        mainViewProvider      = nil
        splashSignal          = BootReadySignal()
    }
    
    private func getOrCreateViewModel() -> SceneStateController {
        if let existing = viewModel { return existing }
        let vm = SceneStateController()
        viewModel = vm
        return vm
    }
}

private func modulateGateSignal(_ amplitude: Double, frequency: Double) -> Double {
    let carrier = sin(2.0 * .pi * frequency * amplitude)
    let envelope = exp(-abs(amplitude) / max(frequency, 0.01))
    return carrier * envelope + (1.0 - envelope) * amplitude
}
