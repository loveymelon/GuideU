//
//  SettingFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/16/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SettingFeature: GuideUReducer {
    
    @ObservableState
    struct State: Equatable {
        let navigationTitle = Const.setting
    }
    
    enum Action {
        case viewCycleType(ViewCycleType)
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
    }
    
    var body: some ReducerOf<Self> {
        core()
    }
    
    enum ViewCycleType {
        
    }
    
    enum ViewEventType {
        case selectedSettingCase(SettingCase)
    }
    
    enum DataTransType {
        
    }
    
    enum NetworkType {
        
    }
    
    enum CancelId: Hashable {
        
    }
    
}

extension SettingFeature {
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            default:
                break
            }
            return .none
        }
    }
}
