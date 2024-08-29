//
//  VideosDTO.swift
//  GuideU
//
//  Created by 김진수 on 8/29/24.
//

import Foundation

struct VideosDTO: DTO {
    let identifier: String
    let title: String
    let channelId: String
    let channelName: String
    let thumbnailUrl: String
    let id: Int
    let updatedAt: String
    
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
