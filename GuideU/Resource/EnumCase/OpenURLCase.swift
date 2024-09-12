//
//  OpenURLCase.swift
//  GuideU
//
//  Created by 김진수 on 9/12/24.
//

import Foundation

enum OpenURLCase: Equatable {
    case youtube(identifier: String)
    
    // youtube 앱
    var appURL: URL? {
        switch self {
        case .youtube(let identifier):
            return URL(string:"youtube://\(identifier)")
        }
    }
    
    // safari 앱
    var webURL: URL? {
        switch self {
        case .youtube(let identifier):
            return URL(string: Const.youtubeBaseString + identifier)
        }
    }
}
