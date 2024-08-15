//
//  LinkDTO.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/15/24.
//

import Foundation

// MARK: - Link
struct LinkDTO: DTO {
    let link: String
    let title: String
    let thumbnailURL: String
    let channel, type: String
    let description: String?
    let follower: Int?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case link, title
        case thumbnailURL = "thumbnail_url"
        case channel, type, description, follower
        case createdAt = "created_at"
    }
}
