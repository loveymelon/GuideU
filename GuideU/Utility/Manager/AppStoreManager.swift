//
//  AppStoreManager.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/19/24.
//

import UIKit

struct AppStoreManager {
    
    private let buildNumber = Const.appVersion
    private let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/" + Const.appID
    
    func latestVersion() async -> String? {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(Const.appID)&country=kr") else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results.first?["version"] as? String else {
                return nil
            }
            return appStoreVersion
            
        } catch {
            return nil
        }
    }
    
    
    // 앱 스토어로 이동 -> urlStr 에 appStoreOpenUrlString 넣으면 이동
    func openAppStore() {
        guard let url = URL(string: appStoreOpenUrlString) else { return }
        Task {
            if await UIApplication.shared.canOpenURL(url) {
                await UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    // 업데이트가 필요한지 확인 후 업데이트 얼럿을 띄우는 메소드
    func isAppStoreVersionHigherThan(_ version: String) async -> Bool {
        guard let latestVersion = await latestVersion(),
              let currentProjectVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }
        
        let splitMarketingVersion = latestVersion.split(separator: ".").map { $0 }
        let splitCurrentProjectVersion = currentProjectVersion.split(separator: ".").map { $0 }
        
        if splitCurrentProjectVersion.count > 0 && splitMarketingVersion.count > 0 {
            
            // 현재 기기의 Major 버전이 앱스토어의 Major 버전보다 낮다면 얼럿을 띄운다.
            if splitCurrentProjectVersion[0] < splitMarketingVersion[0] {
                return true
                // 현재 기기의 Minor 버전이 앱스토어의 Minor 버전보다 낮다면 얼럿을 띄운다.
            } else if splitCurrentProjectVersion[1] < splitMarketingVersion[1] {
                return true
                // Patch의 버전이 다르거나 최신 버전이라면 아무 얼럿도 띄우지 않는다.
            } else {
                print("앱 버전이 같습니다.")
                return false
            }
            
        } else {
            return false
        }
    }
}
