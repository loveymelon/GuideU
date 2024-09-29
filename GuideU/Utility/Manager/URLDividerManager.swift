//
//  URLDividerManager.swift
//  GuideU
//
//  Created by 김진수 on 9/12/24.
//

import Foundation
import ComposableArchitecture

struct URLDividerManager: Sendable {
    
    enum URLTypeCheck {
        case youtubeIdentifier(String)
        case instagramURL(String)
        case twitterURL(String)
        case afreecaURL(String)
    }
    
    func dividerURLType(url: String) -> OpenURLCase {
        if url.localizedStandardContains("youtube.com") {
            if url.localizedStandardContains("channel") || url.localizedStandardContains("user") {
                return .youtubeChannel(channelURLString: url)
            } else if let url = youtube(url) {
                return .youtube(identifier: url)
            } else {
                return .none
            }
        } else if url.localizedStandardContains("instagram.com") {
            return .instagram(instagramURL: url)
        } else if url.localizedStandardContains("twitter.com") {
            return .twitter(twitterURL: url)
        } else if url.localizedStandardContains("afreecatv.com") {
            return .afreecatv(afreecatv: url)
        } else {
            return .none
        }
    }
    
    /// identifier 추출용
    func dividerResult(type: URLTypeCheck) -> String? {
        switch type {
        case .youtubeIdentifier(let string):
            return youtube(string)
        case .instagramURL(_), .twitterURL(_), .afreecaURL(_):
            return nil
        }
    }
}

extension URLDividerManager {
    private func youtube(_ urlString: String) -> String? {
        if let shorts = youtubeShorts(urlString) {
            return shorts
        } else {
            return originalYoutube(urlString)
        }
    }
    
    private func youtubeShorts(_ urlString: String) -> String? {
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
    
    private func originalYoutube(_ urlString: String) -> String? {
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
