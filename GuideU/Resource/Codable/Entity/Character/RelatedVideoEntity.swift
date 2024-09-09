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
}
