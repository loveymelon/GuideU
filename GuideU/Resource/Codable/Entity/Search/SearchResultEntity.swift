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
    
    init(name: String = "", resultType: ResultCase = .character, mean: String? = nil, description: String = "", relatedVideos: [RelatedVideoEntity] = []) {
        self.name = name
        self.resultType = resultType
        self.mean = mean
        self.description = description
        self.relatedVideos = relatedVideos
    }
}
