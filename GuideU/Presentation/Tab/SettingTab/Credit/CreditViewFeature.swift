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
            case sendToFirstMerit
            case sendToSecondMerit
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
    
    enum NetworkType {
        
    }
    
    enum CancelId: Hashable {
        
    }
}

extension CreditViewFeature {
    func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewEvent(.backButtonTapped):
                return .send(.delegate(.backButtonTapped))
                
            case let .viewEvent(.selectedCase(caseOf)):
                switch caseOf {
                case .firstMerit:
                    return .send(.delegate(.sendToFirstMerit))
                case .secondMerit:
                    return .send(.delegate(.sendToSecondMerit))
                }
                
            default:
                break
            }
            return .none
        }
    }
}
