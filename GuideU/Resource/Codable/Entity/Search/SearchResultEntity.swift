//
//  SearchResultEntity.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/13/24.
//

import Foundation

struct SearchResultEntity: Entity {
    let name: String
    let resultType: ResultCase
    let mean: String?
    let description: String
    let relatedVideos: [RelatedVideoEntity]
}
