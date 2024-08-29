//
//  VideoRouter.swift
//  GuideU
//
//  Created by 김진수 on 8/29/24.
//

import Foundation
import Alamofire

enum VideoRouter: Router {
    case fetchVideos(channelId: String, skip: Int, limit: Int)
}

extension VideoRouter {
    var method: HTTPMethod {
        switch self {
        case .fetchVideos:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchVideos:
            return "/api/v1/videos"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .fetchVideos:
            return HTTPHeaders([
                HTTPHeader(name: "Content-Type", value: "application/json")
            ])
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .fetchVideos(channelId, skip, limit):
            return [
                "channel_id": channelId,
                "skip": skip,
                "limit": limit
                ]
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchVideos:
            return nil
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .fetchVideos:
            return .url
        }
    }
}
