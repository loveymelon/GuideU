//
//  VideosEntity.swift
//  GuideU
//
//  Created by 김진수 on 8/29/24.
//

import Foundation

struct VideosEntity: Entity, Identifiable {
    let id = UUID()
    
    let identifier: String
    let videoURL: URL?
    let channelName: String
    let videoImageURL: URL?
    let updatedAt: Date
    let channelImageURL: URL?
    let title: String
    
    init(identifier: String = "", videoURL: URL? = nil, channelName: String = "", videoImageURL: URL? = nil, updatedAt: Date = Date(), channelImageURL: URL? = nil, title: String = "") {
        self.identifier = identifier
        self.videoURL = videoURL
        self.channelName = channelName
        self.videoImageURL = videoImageURL
        self.updatedAt = updatedAt
        self.channelImageURL = channelImageURL
        self.title = title
    }
}
