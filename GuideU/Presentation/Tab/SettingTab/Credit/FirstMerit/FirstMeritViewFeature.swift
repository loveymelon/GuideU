//
//  FirstMeritViewFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/4/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct FirstMeritViewFeature: GuideUReducer {
    
    @ObservableState
    struct State: Equatable {
        let navTitle = Const.FirstTealmRole.mainTitle
        let teamRole = Const.FirstTealmRole.allCases
        let targetTexts = Const.FirstTealmRole.textGrayOptions
    }
    
    enum Action {
        case viewEvent(ViewEventType)
        case delegate(Delegate)
        
        enum Delegate {
            case backButtonTapped
        }
    }
    
    var body: some ReducerOf<FirstMeritViewFeature> {
        core()
    }
    
    enum ViewCycleType {
        
    }
    
    enum ViewEventType {
        case backButtonTapped
    }
    
    enum DataTransType {
        
    }
    
    enum NetworkType {
        
    }
    
    enum CancelId: Hashable {
        
    }
}

extension FirstMeritViewFeature {
    private func core() -> some ReducerOf<Self> {
        Reduce{ state, action in
            switch action {
                
            case .viewEvent(.backButtonTapped):
                return .send(.delegate(.backButtonTapped))
                
            default:
                break
            }
            return .none
        }
    }
}
