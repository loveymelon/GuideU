//
//  RelatedVideoEntity.swift
//  GuideU
//
//  Created by 김진수 on 9/10/24.
//

import Foundation

struct RelatedVideoEntity: Entity {
    let link: String
    let title: String
    let thumbnailURL: URL?
    let channel: String
    let type: RelatedVideoTypeDTO
    
    init(link: String = "", title: String = "", thumbnailURL: URL? = nil, channel: String = "", type: RelatedVideoTypeDTO = .youtube) {
        self.link = link
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.channel = channel
        self.type = type
    }
}
