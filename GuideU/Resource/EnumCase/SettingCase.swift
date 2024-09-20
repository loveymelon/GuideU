//
//  SettingCase.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/16/24.
//

import Foundation
            
enum SettingCase: CaseIterable {
    
    case theme
    case appInfo
    case credit
    
    var title: String {
        switch self {
        case .appInfo:
            "앱 정보"
        case .credit:
            "크레딧"
        case .theme:
            "테마 설정"
        }
    }
    
    var subTitle: String {
        switch self {
        case .appInfo:
            let version = Const.appShortVersion
            return "v" + version
        case .credit:
            return ""
        case .theme:
            return ""
        }
    }
    
    var logoImage: String? {
        switch self {
        case .theme:
            return "Palette"
        case .appInfo:
            return "Ask"
        case .credit:
            return "Users"
        }
    }
}
