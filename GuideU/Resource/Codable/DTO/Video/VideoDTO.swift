//
//  VideoDTO.swift
//  GuideU
//
//  Created by 김진수 on 8/29/24.
//

import Foundation

struct VideoDTO: DTO {
    let reason: String
    let videos: [VideosDTO]
}
