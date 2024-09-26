//
//  OpenURLCase.swift
//  GuideU
//
//  Created by 김진수 on 9/12/24.
//

import Foundation

enum OpenURLCase: Equatable {
    case youtube(identifier: String)
    case youtubeChannel(channelURLString: String)
    case instagram(instagramURL: String)
    case twitter(twitterURL: String)
    case none
    
    // youtube 앱
    var appURL: URL? {
        switch self {
        case .youtube(let identifier):
            return URL(string:"youtube://\(identifier)")
        case .youtubeChannel(let channelURLString):
            return URL(string: channelURLString)
        case .instagram(let instagramURL):
            return URL(string: instagramURL)
        case .twitter(let twitterURL):
            return URL(string: twitterURL)
        case .none:
            return nil
        }
    }
    
    // safari 앱
    var webURL: URL? {
        switch self {
        case .youtube(let identifier):
            return URL(string: Const.youtubeBaseString + identifier)
        case .youtubeChannel(let channelURLString):
            return URL(string: channelURLString)
        case .instagram(let instagramURL):
            return URL(string: instagramURL)
        case .twitter(let twitterURL):
            return URL(string: twitterURL)
        case .none:
            return nil
        }
    }
}
