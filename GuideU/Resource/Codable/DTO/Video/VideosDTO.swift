//
//  VideosDTO.swift
//  GuideU
//
//  Created by 김진수 on 8/29/24.
//

import Foundation

// smallImageURL optional

struct VideosDTO: DTO {
    let identifier: String // videoURL
    let title: String
    let channelId: String
    let channelName: String // channelName
    let thumbnailUrl: String // videoImageURL
    let id: Int
    let updatedAt: String // updateAT
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case title
        case channelId = "channel_id"
        case channelName = "channel_name"
        case thumbnailUrl = "thumbnail_url"
        case id
        case updatedAt = "updated_at"
    }
}

