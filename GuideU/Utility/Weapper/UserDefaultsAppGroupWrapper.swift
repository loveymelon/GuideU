//
//  UserDefaultsAppGroupWrapper.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/9/24.
//

import Foundation

@propertyWrapper
struct UserDefaultsAppGroupWrapper<T: Codable> {
    let key: String
    let placeValue: T
    let appGroupType: AppGroupType
    
    enum AppGroupType {
        case youtube
        
        var name: String {
            switch self {
            case .youtube:
                return "group.guideu.youtube"
            }
        }
    }
    
    private var userDefaults: UserDefaults? {
        return UserDefaults(suiteName: appGroupType.name)
    }
    
    var wrappedValue: T {
        get {
            guard let userDefaults,
                  let data = userDefaults.data(forKey: key),
                  let value = try? CodableManager.shared.jsonDecoding(model: T.self, from: data) else {
                return placeValue
            }
            return value
        } set {
            guard let userDefaults,
                  let data = try? CodableManager.shared.jsonEncoding(from: newValue) else {
                return
            }
            userDefaults.setValue(data, forKey: key)
        }
    }
}
