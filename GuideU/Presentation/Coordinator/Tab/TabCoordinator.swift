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
        var searchTabState = SearchCoordinator.State.initialState
        var historyTabState = HistoryCoordinator.State.initialState
        var settingTabState = SettingCoordinator.State.initialState
    }
    
    enum Action {
        case delegate(Delegate)
        case tabCase(TabCase)
        
        /// TabAction
        case homeTabAction(HomeCoordinator.Action)
        case searchTabAction(SearchCoordinator.Action)
        case historyTabAction(HistoryCoordinator.Action)
        case settingTabAction(SettingCoordinator.Action)
        
        enum Delegate {
            case detailButtonTapped(String)
        }
    }
    
    enum CancelID: Hashable {
        case parentAction
    }
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.homeTabState, action: \.homeTabAction) {
            HomeCoordinator()
        }
        Scope(state: \.searchTabState, action: \.searchTabAction) {
            SearchCoordinator()
        }
        Scope(state: \.historyTabState, action: \.historyTabAction) {
            HistoryCoordinator()
        }
        Scope(state: \.settingTabState, action: \.settingTabAction) {
            SettingCoordinator()
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
                
            case let .homeTabAction(.delegate(.detailButtonTapped(identifier))):
                return .run { send in
                    await send(.delegate(.detailButtonTapped(identifier)))
                }
                
            case let .historyTabAction(.delegate(.detailButtonTapped(identifier))):
                return .run { send in
                    await send(.delegate(.detailButtonTapped(identifier)))
                }
                
            case .homeTabAction(.delegate(.searchBarTapped)):
                state.currentTab = .searchTab
                
            default:
                break
            }
            
            return .none
        }
    }
}
