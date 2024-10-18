//
//  MeritFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MeritFeature {
    
    @ObservableState
    struct State: Equatable {
        let meritCase: Const.CreditCase
        var navTitle = ""
        var teamRole: [any TeamRoleProtocol] = []
        var targetTexts: [String] = []
        
        static func == (lhs: State, rhs: State) -> Bool {
            return lhs.meritCase == rhs.meritCase &&
            lhs.navTitle == rhs.navTitle &&
            lhs.targetTexts == rhs.targetTexts
        }
    }
    
    enum Action {
        case viewCycle(ViewCycleType)
        case viewEvent(ViewEventType)
        case delegate(Delegate)
        
        enum Delegate {
            case backButtonTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        core()
    }
    
    enum ViewCycleType {
        case onAppear
    }
    
    enum ViewEventType {
        case backButtonTapped
    }
    
    enum DataTransType {
        
    }
}

extension MeritFeature {
    private func core() -> some ReducerOf<Self> {
        Reduce{ state, action in
            switch action {
                
            case .viewCycle(.onAppear):
                switch state.meritCase {
                case .firstMerit:
                    state.navTitle = Const.FirstTealmRole.mainTitle
                    state.teamRole = Const.FirstTealmRole.allCases
                    state.targetTexts = Const.FirstTealmRole.textGrayOptions
                case .secondMerit:
                    state.navTitle = Const.SecondTealmRole.mainTitle
                    state.teamRole = Const.SecondTealmRole.allCases
                    state.targetTexts = Const.SecondTealmRole.textGrayOptions
                }
                
            case .viewEvent(.backButtonTapped):
                return .send(.delegate(.backButtonTapped))
                
            default:
                break
            }
            return .none
        }
    }
}
