//
//  VideoHistoryRequestDTO.swift
//  GuideU
//
//  Created by 김진수 on 9/10/24.
//

import Foundation
import RealmSwift

class VideoHistoryRequestDTO: Object {
    @Persisted(primaryKey: true) var identifier: String
    
    @Persisted var title: String
    @Persisted var videoURL: String
    @Persisted var channelName: String
    @Persisted var thumbnail: String
    @Persisted var updatedAt: Date
    @Persisted var watchedAt: Date
    
    convenience init(identifier: String, title: String, videoURL: String, channelName: String, thumbnail: String, updatedAt: Date, watchedAt: Date) {
        self.init()
        
        self.identifier = identifier
        self.title = title
        self.videoURL = videoURL
        self.channelName = channelName
        self.thumbnail = thumbnail
        self.updatedAt = updatedAt
        self.watchedAt = watchedAt
    }
}
