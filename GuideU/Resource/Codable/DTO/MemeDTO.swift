//
//  MemeDTO.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import Foundation

struct BookElementDTO: DTO {
    let timestamp: Int
    let memes: [MemeDTO]
}

/// MemeDTO
struct MemeDTO: DTO {
    let name, definition, description: String
    let synonyms: [String]
    let relatedVideos: [RelatedVideoDTO]
    let isDetectable: Bool
    let id: Int
    let duplicates: [DuplicateDTO]?
    let appearanceTime: Int?

    enum CodingKeys: String, CodingKey {
        case name, definition, description, synonyms
        case relatedVideos = "related_videos"
        case isDetectable = "is_detectable"
        case id
        case duplicates
        case appearanceTime = "appearance_time"
    }
}
