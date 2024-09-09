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
        var currentTabCoordinator: TabCoordinator.State = TabCoordinator.State()
    }
    
    enum Action {
        case router(IdentifiedRouterActionOf<RootScreen>)
        
        case tabCoordinatorAction(TabCoordinator.Action)
        
        case viewLifeCycle(ViewLifeCycle)
        case parentAction(ParentAction)

        enum ParentAction {
            case checkURL
        }
    }
    
    enum RootCoordinatorViewState: Equatable {
        case start
        case tab
    }
    
    enum ViewLifeCycle {
        case background
            
        case inactive
            
        case active
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.currentTabCoordinator, action: \.tabCoordinatorAction) {
            TabCoordinator()
        }
        
        Reduce { state, action in
            switch action {
                
            case let .router(.routeAction(id: _, action: .splash(.delegate(.isFirstUser(trigger))))):

                if trigger {
                    state.routes.push(.onboardPage(OnboardPageFeature.State()))
                } else {
                    state.viewState = .tab
                }
                
//            case .router(.routeAction(id: _, action: .onboardPage(.delegate(.startButtonTapped)))):
//                return changeTabView(state: &state)
                
            case .viewLifeCycle(.active):
                print("액티브")
                print("URL -> ", UserDefaultsManager.sharedURL)
                
                return .run { send in
                    await send(.parentAction(.checkURL))
                }
                
            case .viewLifeCycle(.inactive):
                print("IN 액티브")
                
            case .parentAction(.checkURL):
                return .run { send in
                    await send(.tabCoordinatorAction(.paretnAction(.checkURL)))
                }
                
            default:
                break
            }
            
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
//        .ifLet(\.currentTabCoordinator, action: \.tabCoordinatorAction) {
//            TabCoordinator()
//        }
    }
}
