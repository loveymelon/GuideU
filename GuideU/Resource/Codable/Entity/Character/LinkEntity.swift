//
//  LinkEntity.swift
//  GuideU
//
//  Created by 김진수 on 8/28/24.
//

import Foundation

struct LinkEntity: Entity {
    let link: String
    let title: String
    let thumbnailURL: String
    let channel: String
    let type: RelatedVideoTypeDTO
    let description: String?
    let createdAt: String?
}
