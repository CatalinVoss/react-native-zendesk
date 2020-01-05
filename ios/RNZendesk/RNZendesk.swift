//
//  RNZendesk.swift
//  RNZendesk
//
//  Created by David Chavez on 24.04.18.
//  Copyright © 2018 David Chavez. All rights reserved.
//

import UIKit
import Foundation
import ZendeskSDK
import ZendeskCoreSDK
import CommonUISDK

@objc(RNZendesk)
class RNZendesk: RCTEventEmitter, UINavigationControllerDelegate {

    override public static func requiresMainQueueSetup() -> Bool {
        return false;
    }
    
    @objc(constantsToExport)
    override func constantsToExport() -> [AnyHashable: Any] {
        return [:]
    }
    
    @objc(supportedEvents)
    override func supportedEvents() -> [String] {
        return []
    }
    
    
    // MARK: - Initialization

    @objc(initialize:)
    func initialize(config: [String: Any]) {
        guard
            let appId = config["appId"] as? String,
            let clientId = config["clientId"] as? String,
            let zendeskUrl = config["zendeskUrl"] as? String else { return }
        
        Zendesk.initialize(appId: appId, clientId: clientId, zendeskUrl: zendeskUrl)
        Support.initialize(withZendesk: Zendesk.instance)

        // UI Config
        Theme.currentTheme.primaryColor = #colorLiteral(red: 0.2735899687, green: 0.7367950082, blue: 0.7950475812, alpha: 1)
    }
    
    // MARK: - Indentification
    
    @objc(identifyJWT:)
    func identifyJWT(token: String?) {
        guard let token = token else { return }
        let identity = Identity.createJwt(token: token)
        Zendesk.instance?.setIdentity(identity)
    }
    
    @objc(identifyAnonymous:email:)
    func identifyAnonymous(name: String?, email: String?) {
        let identity = Identity.createAnonymous(name: name, email: email)
        Zendesk.instance?.setIdentity(identity)
    }

    @objc(registerPushNotifications:)
    func registerPushNotifications(token: String?) {
        // Ensure push notifications are fired up properly at this point
        // Workaround for iOS 10+ issue with firebase React Native wrapper
        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
              let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
              UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            }
            
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        guard let token = token else { return }
        let locale = NSLocale.preferredLanguages.first ?? "en"
        ZDKPushProvider(zendesk: Zendesk.instance!).register(deviceIdentifier: token, locale: locale) { (pushResponse, error) in
            if error != nil {
                print("Couldn't register device: \(token). Error: \(error)")
            } else {
                print("Successfully registered device: \(token)")
            }
        }
    }
    
    @objc(unregisterPushNotifications)
    func unregisterPushNotifications() {
        ZDKPushProvider(zendesk: Zendesk.instance!).unregisterForPush()
    }

    // MARK: - UI Methods
    
    @objc(showHelpCenter:)
    func showHelpCenter(with options: [String: Any]) {
        DispatchQueue.main.async {
            let hcConfig = HelpCenterUiConfiguration()
            hcConfig.showContactOptionsOnEmptySearch = (options["showContactOptionsOnEmptySearch"] as? Bool) ?? false
            let helpCenter = HelpCenterUi.buildHelpCenterOverviewUi(withConfigs: [hcConfig])
            
            let nvc = FrameNavigationController(rootViewController: helpCenter)
            nvc.delegate = self
            nvc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            UIApplication.shared.keyWindow?.rootViewController?.present(nvc, animated: false, completion: nil)
        }
    }
    
    @objc(showNewTicket:)
    func showNewTicket(with options: [String: Any]) {
        DispatchQueue.main.async {
            let config = RequestUiConfiguration()
            if let tags = options["tags"] as? [String] {
                config.tags = tags
            }
            let requestScreen = RequestUi.buildRequestUi(with: [config])
            
            let nvc = FrameNavigationController(rootViewController: requestScreen)
            nvc.delegate = self
            UIApplication.shared.keyWindow?.rootViewController?.present(nvc, animated: false, completion: nil)
        }
    }

    @objc(showTicketList)
    func showTicketList() {
        DispatchQueue.main.async {
            let requestListController = RequestUi.buildRequestList()
            
            let nvc = FrameNavigationController(rootViewController: requestListController)
            nvc.delegate = self
            nvc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            UIApplication.shared.keyWindow?.rootViewController?.present(nvc, animated: false)
        }
    }

    @objc func showTicketListWithCustomAction(_ callback: @escaping RCTResponseSenderBlock) -> Void {
    }
    
    // MARK: - View Controller Lifecycle
    
    // Hack away Zendesk exit button whenever we return to root
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let controller = navigationController as! FrameNavigationController
        controller.clearLeftButton()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let controller = navigationController as! FrameNavigationController
        controller.clearLeftButton()
    }
}
