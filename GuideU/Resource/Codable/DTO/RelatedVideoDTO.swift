//
//  RelatedVideoDTO.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import Foundation

// MARK: - RelatedVideo
struct RelatedVideoDTO: DTO {
    let link: String
    let title: String
    let thumbnailURL: String
    let channel: String
    let type: RelatedVideoTypeDTO

    enum CodingKeys: String, CodingKey {
        case link, title
        case thumbnailURL = "thumbnail_url"
        case channel, type
    }
}
