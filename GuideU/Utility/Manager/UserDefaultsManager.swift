//
//  UserDefaultsManager.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import Foundation

// MARK: Swift 6 대응
/// enum -> Actor 로 변경 데이터 레이스 발생 가능성이 있다고 판단
final actor UserDefaultsManager {
    
    enum Key: String {
        case isFirst
        case sharedURL
        case currentColorSetting
        
        var value: String {
            return self.rawValue
        }
    }
    
    @UserDefaultsWrapper(key: Key.isFirst.value, placeValue: true)
    static var isFirst: Bool
    
    @UserDefaultsAppGroupWrapper(key: Key.sharedURL.value, placeValue: nil, appGroupType: .youtube)
    static var sharedURL: String?
    
    @UserDefaultsWrapper(key: Key.currentColorSetting.value, placeValue: 0)
    static var colorCase: Int
}
