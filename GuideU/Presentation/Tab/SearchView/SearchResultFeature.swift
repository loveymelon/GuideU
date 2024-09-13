//
//  SearchResultFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchResultFeature: GuideUReducer {
    
    @ObservableState
    struct State: Equatable {
        var searchResultEntity: SearchResultEntity? = nil
        let currentSearchKeyword: String
        
    }
    
    enum Action {
        case viewCycleType(ViewCycleType)
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        case delegate(Delegate)
        
        enum Delegate {
            
        }
    }
    
    enum ViewCycleType {
        case viewOnAppear
    }
    
    enum ViewEventType {
        
    }
    
    enum DataTransType {
        
    }
    
    enum NetworkType {
        
    }
    
    enum CancelId: Hashable {
        
    }
    
    var body: some ReducerOf<Self> {
        core()
    }
}

extension SearchResultFeature {
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
