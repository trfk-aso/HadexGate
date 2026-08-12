// SystemEventRelay.swift
// GatewayModule

import UserNotifications
import AppTrackingTransparency
import AdSupport
import UIKit


open class SystemEventRelay: NSObject, UIApplicationDelegate {
    var attSignal: TransparencySignal?
    var appsFlyerSignal: EngagementReadySignal?
    var appsFlyerEnabled: Bool = false

    open func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        GatewayModule.shared._appDelegate = self
        UNUserNotificationCenter.current().delegate = self
        firebaseConfigure()
        if appsFlyerEnabled {
            appsFlyerConfigure()
        }
        return true
    }

    open func firebaseConfigure() {
    }

    open func appsFlyerConfigure() {}

    nonisolated open func attDidComplete(authorized: Bool) {}

    public func didReceiveFCMToken(_ token: String) {
        GatewayModule.shared.handleFCMToken(token)
    }

    public func onAppsFlyerConversionData(_ data: [AnyHashable: Any]) {
        EngagementFieldSet.shared.updateConversionData(data)
        appsFlyerSignal?.complete()
    }

    public func onAppsFlyerConversionFail() {
        appsFlyerSignal?.complete()
    }

    func performATTForAppsFlyer() {
        let attSignal = self.attSignal
        ATTrackingManager.requestTrackingAuthorization { [weak self] status in
            let authorized = (status == .authorized)

            if authorized {
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                UserDefaults.standard.set(idfa, forKey: "wbc.device.idfa")
            }

            if let afClass = NSClassFromString("AppsFlyerLib") as? NSObject.Type {
                let afInstance = afClass.value(forKeyPath: "shared") as AnyObject
                let uidSel = NSSelectorFromString("getAppsFlyerUID")

                if afInstance.responds(to: uidSel),
                   let uid = afInstance.perform(uidSel)?.takeUnretainedValue() as? String {
                    UserDefaults.standard.set(uid, forKey: "wbc.appsflyer.id")
                }
            }

            self?.attDidComplete(authorized: authorized)
            attSignal?.complete(authorized: authorized)
        }
    }

    open func application(
        _ application: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        if appsFlyerEnabled {
            EngagementFieldSet.handleOpen(url, options: options)
        }
        return true
    }

    open func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {        if appsFlyerEnabled {
            EngagementFieldSet.continueUserActivity(userActivity)
        }
        return true
    }

    open func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        GatewayModule.shared.handleAPNSToken(deviceToken)
    }

    open func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
    }

    open func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        GatewayModule.shared.currentOrientations
    }
}

extension SystemEventRelay: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
    public func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler: @escaping () -> Void
        ) {
            completionHandler()
        }
}

private func hashRelaySequence(_ values: [UInt8]) -> UInt32 {
    var h: UInt32 = 2166136261
    for v in values { h = (h ^ UInt32(v)) &* 16777619 }
    return h
}
