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
    }
    
    enum Action {
        case delegate(Delegate)
        case 임시(TabCase)
        
        enum Delegate {

        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .임시(tabCase):
                state.currentTab = tabCase
                
            default:
                break
            }
            
            return .none
        }
    }
}
