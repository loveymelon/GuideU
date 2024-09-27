//
//  SearchCoordinator.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/11/24.
//

import Foundation
import ComposableArchitecture
@preconcurrency import TCACoordinators

@Reducer(state: .equatable)
enum SearchScreen {
    case search(SearchFeature)
    case searchResult(SearchResultFeature)
}

@Reducer
struct SearchCoordinator {
    
    @ObservableState
    struct State: Equatable, Sendable {
        static let initialState = State(routes: [.root(.search(SearchFeature.State()), embedInNavigationView: true)])
        
        var routes: IdentifiedArrayOf<Route<SearchScreen.State>>
        
    }
    
    enum Action {
        case router(IdentifiedRouterActionOf<SearchScreen>)
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .router(.routeAction(id: .search, action: .search(.delegate(.openToResultView(suggestEntity))))):
                state.routes.push(.searchResult(SearchResultFeature.State(suggestEntity: suggestEntity)))
                
            case .router(.routeAction(id: .searchResult, action: .searchResult(.delegate(.backButtonTapped)))):
                state.routes.pop()
            default:
                break
            }
            
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
