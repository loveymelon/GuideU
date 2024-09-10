//
//  RootCoordinator.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

@Reducer(state: .equatable)
enum RootScreen {
    case splash(SplashFeature)
    case onboardPage(OnboardPageFeature)
}

@Reducer
struct RootCoordinator {
    
    @ObservableState
    struct State {
        static let initialState = State(routes: [.root(.splash(SplashFeature.State()), embedInNavigationView: true)])
        
        var routes: IdentifiedArrayOf<Route<RootScreen.State>>
        
        var viewState: RootCoordinatorViewState = .start
        var tabNavCoordinator: TabNavCoordinator.State = TabNavCoordinator.State.initialState
    }
    
    enum Action {
        case router(IdentifiedRouterActionOf<RootScreen>)
        
        case tabNavCoordinatorAction(TabNavCoordinator.Action)
    }
    
    enum RootCoordinatorViewState: Equatable {
        case start
        case tab
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.tabNavCoordinator, action: \.tabNavCoordinatorAction) {
            TabNavCoordinator()
        }
        
        Reduce { state, action in
            switch action {
                
            case let .router(.routeAction(id: _, action: .splash(.delegate(.isFirstUser(trigger))))):

                if trigger {
                    state.routes.push(.onboardPage(OnboardPageFeature.State()))
                } else {
                    state.viewState = .tab
                }
                
            default:
                break
            }
            
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
