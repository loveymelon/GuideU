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
            Const.appInfo
        case .credit:
            Const.credit
        case .theme:
            Const.theme
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
