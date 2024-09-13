//
//  HistoryVideosEntity.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/13/24.
//

import Foundation

struct HistoryVideosEntity: Entity {
    let lastWatched: String
    let videosEntity: [VideosEntity]
}
