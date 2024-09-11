//
//  SearchCoordinator.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/11/24.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

@Reducer(state: .equatable)
enum SearchScreen {
    case search(SearchFeature)
}

@Reducer
struct SearchCoordinator {
    
    @ObservableState
    struct State: Equatable {
        static let initialState = State(routes: [.root(.search(SearchFeature.State()), embedInNavigationView: true)])
        
        var routes: IdentifiedArrayOf<Route<SearchScreen.State>>
        
    }
    
    enum Action {
        case router(IdentifiedRouterActionOf<SearchScreen>)
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            default:
                break
            }
            
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
