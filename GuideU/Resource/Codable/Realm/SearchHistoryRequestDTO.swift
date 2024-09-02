//
//  SearchHistoryRequestDTO.swift
//  GuideU
//
//  Created by 김진수 on 9/2/24.
//

import Foundation
import RealmSwift

class SearchHistoryRequestDTO: Object {
    @Persisted(primaryKey: true) var history: String
    
    @Persisted var date: Date
    
    convenience init(history: String, date: Date) {
        self.init()
        
        self.history = history
        self.date = date
    }
}
