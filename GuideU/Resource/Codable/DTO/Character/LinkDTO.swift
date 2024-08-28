//
//  LinkDTO.swift
//  GuideU
//
//  Created by 김진수 on 8/28/24.
//

import Foundation

struct LinkDTO: DTO {
    let link: String
    let title: String
    let thumbnailURL: String
    let channel: String
    let type: RelatedVideoTypeDTO
    let description: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case link, title
        case thumbnailURL = "thumbnail_url"
        case channel, type, description
        case createdAt = "created_at"
    }
}
