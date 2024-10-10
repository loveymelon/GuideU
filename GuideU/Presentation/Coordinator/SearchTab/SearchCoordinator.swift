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
        
        case parent(ParentAction)
        
        enum ParentAction {
            case resetToSearchView
        }
    }
    
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .router(.routeAction(id: .search, action: .search(.delegate(.openToResultView(searchResultEntity))))):
                state.routes.push(.searchResult(SearchResultFeature.State(searchResultEntity: searchResultEntity)))
                
            case .router(.routeAction(id: .searchResult, action: .searchResult(.delegate(.backButtonTapped)))):
                state.routes.pop()
                
            case .parent(.resetToSearchView):
                state.routes.popToRoot()
                return .send(.router(.routeAction(id: .search, action: .search(.parent(.resetToSearchView)))))
            default:
                break
            }
            
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
