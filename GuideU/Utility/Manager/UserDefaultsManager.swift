//
//  UserDefaultsManager.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import Foundation

enum UserDefaultsManager {
    
    enum Key: String {
        case isFirst
        
        var value: String {
            return self.rawValue
        }
    }
    
    @UserDefaultsWrapper(key: Key.isFirst.value, placeValue: true)
    static var isFirst: Bool
}
