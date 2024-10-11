//
//  OpenURLCase.swift
//  GuideU
//
//  Created by 김진수 on 9/12/24.
//

import Foundation

enum OpenURLCase: Equatable {
    case youtube(identifier: String)
    case originalYoutube(originURL: String)
    case instagram(instagramURL: String)
    case twitter(twitterURL: String)
    case afreecatv(afreecatv: String)
    case naverCafe(cafeURL: String)
    case none(url: String)
    
    // youtube 앱
    var appURL: URL? {
        switch self {
        case .youtube(let identifier):
            return URL(string:"youtube://\(identifier)")
        case .originalYoutube(let originURL):
            return URL(string: originURL)
        case .instagram(let instagramURL):
            return URL(string: instagramURL)
        case .twitter(let twitterURL):
            return URL(string: twitterURL)
        case .afreecatv(let afreecatvURL):
            return URL(string: afreecatvURL)
        case .naverCafe(let naverCafeURL):
            return URL(string: naverCafeURL)
        case .none:
            return nil
        }
    }
    
    // safari 앱
    var webURL: URL? {
        switch self {
        case .youtube(let identifier):
            return URL(string: Const.youtubeBaseString + identifier)
        case .originalYoutube(let originURL):
            return URL(string: originURL)
        case .instagram(let instagramURL):
            return URL(string: instagramURL)
        case .twitter(let twitterURL):
            return URL(string: twitterURL)
        case .afreecatv(let affrecatvURL):
            return URL(string: affrecatvURL)
        case .naverCafe(let naverCafeURL):
            return URL(string: naverCafeURL)
        case .none(let url):
            return URL(string: url)
        }
    }
}
