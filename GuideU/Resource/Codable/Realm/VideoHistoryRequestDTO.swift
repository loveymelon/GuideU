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
    @Persisted var channelID: String
    @Persisted var channelName: String
    @Persisted var thumbnail: String
    @Persisted var id: String
    @Persisted var updatedAt: Date
    @Persisted var watchedAt: Date
    
    convenience init(identifier: String, title: String, channelID: String, channelName: String, thumbnail: String, id: String, updatedAt: Date, watchedAt: Date) {
        self.init()
        
        self.identifier = identifier
        self.title = title
        self.channelID = channelID
        self.channelName = channelName
        self.thumbnail = thumbnail
        self.id = id
        self.updatedAt = updatedAt
        self.watchedAt = watchedAt
    }
}
