//
//  OpenURLManager.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/12/24.
//

import SwiftUI

struct OpenURLManager {
    
    func openAppUrl(urlCase: OpenURLCase) async {
        if let appURL = urlCase.appURL {
            if await !openAppUrl(url: appURL) {
                guard let webUrl = urlCase.webURL else {
                    return
                }
                await openAppUrl(url: webUrl)
            }
        } else if let webUrl = urlCase.webURL {
            await openAppUrl(url: webUrl)
        }
    }
    /*
     Sending value of non-Sendable type '[UIApplication.OpenExternalURLOptionsKey : Any]'
     with later accesses from nonisolated context to main actor-isolated context risks causing data races
     */
    @MainActor
    @discardableResult
    func openAppUrl(url: URL) -> Bool {
        let application = UIApplication.shared
        
        if application.canOpenURL(url) {
            application.open(url)
            return true
        } else {
            return false
        }
    }
}

extension OpenURLManager: EnvironmentKey {
   static let defaultValue = Self()
}

extension EnvironmentValues {
    var openURLManager: OpenURLManager {
        get { self[OpenURLManager.self] }
        set { self[OpenURLManager.self] = newValue }
    }
}
