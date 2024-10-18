//
//  CreditViewFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/4/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CreditViewFeature: GuideUReducer {
    
    @ObservableState
    struct State: Equatable {
        let creditCase = Const.CreditCase.allCases
        let navTitle = Const.credit
    }
    
    enum Action {
        case viewCycle(ViewCycleType)
        case viewEvent(ViewEventType)
        
        case delegate(Delegate)
        
        enum Delegate {
            case backButtonTapped
            case sendToMerit(Const.CreditCase)
        }
    }
    
    var body: some ReducerOf<CreditViewFeature> {
        core()
    }
    
    enum ViewCycleType {
        
    }
    
    enum ViewEventType {
        case backButtonTapped
        case selectedCase(Const.CreditCase)
    }
    
    enum DataTransType {
        
    }
}

extension CreditViewFeature {
    func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewEvent(.backButtonTapped):
                return .send(.delegate(.backButtonTapped))
                
            case let .viewEvent(.selectedCase(caseOf)):
                return .send(.delegate(.sendToMerit(caseOf)))
                
            default:
                break
            }
            return .none
        }
    }
}
