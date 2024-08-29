//
//  VideosEntity.swift
//  GuideU
//
//  Created by 김진수 on 8/29/24.
//

import Foundation

struct VideosEntity: Entity {
    let videoURL: URL?
    let channelName: String
    let videoImageURL: URL?
    let updatedAt: Date
    let channelImageURL: URL?
}
