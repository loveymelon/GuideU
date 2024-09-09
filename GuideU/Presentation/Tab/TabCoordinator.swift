//
//  TabCoordinator.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import Foundation
import ComposableArchitecture


@Reducer
struct TabCoordinator {
    
    @ObservableState
    struct State: Equatable {
        var currentTab = TabCase.home
        
        /// TabState
        var homeTabState = HomeCoordinator.State.initialState
        var morePersonTabState = MorePersonCoordinator.State.initialState
    }
    
    enum Action {
        case delegate(Delegate)
        case paretnAction(ParentAction)
        case tabCase(TabCase)
        
        /// TabAction
        case homeTabAction(HomeCoordinator.Action)
        case morePersonTabAction(MorePersonCoordinator.Action)
        
        enum Delegate {
            
        }
        
        enum ParentAction {
            case checkURL
        }
    }
    
    enum CancelID: Hashable {
        case parentAction
    }
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.homeTabState, action: \.homeTabAction) {
            HomeCoordinator()
        }
        Scope(state: \.morePersonTabState, action: \.morePersonTabAction) {
            MorePersonCoordinator()
        }
        
        core()
    }
}

extension TabCoordinator {
    private func core() -> some ReducerOf<Self>{
        Reduce { state, action in
            switch action {
                
            case let .tabCase(tabCase):
                state.currentTab = tabCase
                
            case .paretnAction(.checkURL):
                return .run { send in
                    await send(.morePersonTabAction(.parentAction(.checkURL)))
                }
                
            default:
                break
            }
            
            return .none
        }
    }
}
