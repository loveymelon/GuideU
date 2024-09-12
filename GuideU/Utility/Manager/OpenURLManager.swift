//
//  OpenURLManager.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/12/24.
//

import SwiftUI

/// NO Dependency TCA PLZ 알겠죠? 이건 UI 관할 입니다.
/// okokok
struct OpenURLManager {
    
    func openAppUrl(urlCase: OpenURLCase) {
        if let appURL = urlCase.appURL {
            if !openAppUrl(url: appURL) {
                guard let webUrl = urlCase.webURL else {
                    return
                }
                openAppUrl(url: webUrl)
            }
        } else if let webUrl = urlCase.webURL {
            openAppUrl(url: webUrl)
        }
    }
    
    @discardableResult
    private func openAppUrl(url: URL) -> Bool {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
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
