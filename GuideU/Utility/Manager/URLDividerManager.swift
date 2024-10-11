//
//  URLDividerManager.swift
//  GuideU
//
//  Created by 김진수 on 9/12/24.
//

import Foundation
import ComposableArchitecture

struct URLDividerManager: Sendable {
    
    enum URLTypeCheck { // 이건좀 고민해보셈. 이게더 이상함.
        case youtubeIdentifier(String)
        case instagramURL(String)
        case twitterURL(String)
        case afreecaURL(String)
        case naverCafeURL(String)
    }
    
    func dividerURLType(url: String) -> OpenURLCase {
        guard let social = SocialType.getCase(url) else {
            return .none(url: url)
        }
        
        switch social {
        case .youtube:
            return .originalYoutube(originURL: url)
        case .instagram:
            return .instagram(instagramURL: url)
        case .twitter:
            return .twitter(twitterURL: url)
        case .afreeca:
            return .afreecatv(afreecatv: url)
        case .naverCafe:
            return .naverCafe(cafeURL: url)
        }
    }
    
    /// identifier 추출용
    func dividerResult(type: URLTypeCheck) -> String? {
        switch type {
        case .youtubeIdentifier(let string):
            return youtubeChecker(string)
        case .instagramURL(_), .twitterURL(_), .afreecaURL(_), .naverCafeURL(_):
            return nil
        }
    }
}

extension URLDividerManager {
    private func youtubeURLChecker(_ url: String) -> OpenURLCase {
        if url.contains("channel") || url.contains("user") {
            return .originalYoutube(originURL: url)
        } else if let url = youtubeChecker(url) {
            return .youtube(identifier: url)
        } else {
            return OpenURLCase.none(url: url)
        }
    }
    
    private func youtubeChecker(_ urlString: String) -> String? {
        if let shorts = ifYoutubeShorts(urlString) {
            return shorts
        } else if let beYoutube = ifBEYoutube(urlString) {
            return beYoutube
        } else {
            return ifOriginalYoutube(urlString)
        }
    }
    
    private func ifYoutubeShorts(_ urlString: String) -> String? {
        if let range = urlString.range(of: "shorts/") {
            let videoId = urlString[range.upperBound...]
            
            if let endRange = videoId.range(of: "?") {
                let finalVideoId = videoId[..<endRange.lowerBound]
                return String(finalVideoId)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    private func ifBEYoutube(_ urlString: String) -> String? {
        if let range = urlString.range(of: "be/") {
            
            let videoId = urlString[range.upperBound...]
            
            if let endRange = videoId.range(of: "?") {
                let finalVidoeId = videoId[..<endRange.lowerBound]
                return String(finalVidoeId)
            } else {
                return String(videoId)
            }
            
        } else {
            return nil
        }
        
    }
    
    private func ifOriginalYoutube(_ urlString: String) -> String? {
        guard let url = URL(string: urlString),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }
        
        if let vValue = queryItems.first(where: { $0.name == "v" })?.value {
            return vValue
        } else if let siValue = queryItems.first(where: { $0.name == "si" })?.value {
            return siValue
        } else {
            return nil
        }
    }
}

extension URLDividerManager: DependencyKey {
    static let liveValue = Self()
}

extension DependencyValues {
    var urlDividerManager: URLDividerManager {
        get { self[URLDividerManager.self] }
        set { self[URLDividerManager.self] = newValue }
    }
}
