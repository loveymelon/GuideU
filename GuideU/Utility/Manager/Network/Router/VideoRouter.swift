//
//  VideoRouter.swift
//  GuideU
//
//  Created by 김진수 on 8/29/24.
//

import Foundation
import Alamofire

enum VideoRouter: Router {
    case fetchVideos(channelId: String = "", skip: Int = 0, limit: Int = 100, identifier: String = "")
    case fetchCharacters(String)
    case fetchMemes(String)
}

extension VideoRouter {
    var method: HTTPMethod {
        switch self {
        case .fetchVideos, .fetchCharacters, .fetchMemes:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchVideos:
            return "/api/v1/videos"
        case let .fetchCharacters(identifiable):
            return "/api/v1/videos/\(identifiable)/characters"
        case let .fetchMemes(identifiable):
            return "/api/v1/videos/\(identifiable)/memes"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .fetchVideos, .fetchCharacters, .fetchMemes:
            return HTTPHeaders([
                HTTPHeader(name: "Content-Type", value: "application/json")
            ])
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .fetchVideos(channelId, skip, limit, identifier):
            if identifier.isEmpty {
                return [
                    "channel_id": channelId,
                    "skip": skip,
                    "limit": limit,
                    "status": "aaaa"
                ]
            } else if !identifier.isEmpty {
                return [
                    "identifier": identifier
                ]
            } else {
                return [
                    "skip": skip,
                    "limit": limit
                ]
            }
        case .fetchCharacters, .fetchMemes:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchVideos, .fetchCharacters, .fetchMemes:
            return nil
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .fetchVideos, .fetchCharacters, .fetchMemes:
            return .url
        }
    }
}
