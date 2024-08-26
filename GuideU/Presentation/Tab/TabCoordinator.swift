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
    }
    
    enum Action {
        case delegate(Delegate)
        case tabCase(TabCase)
        
        /// TabAction
        case homeTabAction(HomeCoordinator.Action)
        
        enum Delegate {

        }
    }
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.homeTabState, action: \.homeTabAction) {
            HomeCoordinator()
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
                
            default:
                break
            }
            
            return .none
        }
    }
}
