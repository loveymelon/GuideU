//
//  MemeEntity.swift
//  GuideU
//
//  Created by 김진수 on 9/10/24.
//

import Foundation

struct MemeEntity: Entity, Identifiable {
    let name: String, definition, description: String
    let synonyms: [String]
    let relatedVideos: [RelatedVideoEntity]
    let isDetectable: Bool
    let id: Int
    let duplicates: [DuplicateEntity]
}
