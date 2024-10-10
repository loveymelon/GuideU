//
//  HomeCoordinator.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/26/24.
//

import Foundation
import ComposableArchitecture
@preconcurrency import TCACoordinators


@Reducer(state: .equatable)
enum HomeScreen {
    case home(MoreCharacterFeature)
}

@Reducer
struct HomeCoordinator {
    
    @ObservableState
    struct State: Equatable, Sendable {
        static let initialState = State(routes: [.root(.home(MoreCharacterFeature.State()), embedInNavigationView: true)])
        var routes: IdentifiedArrayOf<Route<HomeScreen.State>>
    }
    
    enum Action {
        
        case router(IdentifiedRouterActionOf<HomeScreen>)
        
        /// 상위뷰에게 전달
        case delegate(Delegate)

        /// 상위뷰에게서 전달받음
        case parent(ParentAction)
        
        enum Delegate {
            case detailButtonTapped(String)
            case searchBarTapped
        }
        
        enum ParentAction {
            case resetToHome
        }
    }
    
    var body: some ReducerOf<Self> {
        core()
    }
}

extension HomeCoordinator {
    
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .router(.routeAction(id: .home, action: .home(.delegate(.detailButtonTapped(identifier))))):
                return .run { send in
                    await send(.delegate(.detailButtonTapped(identifier)))
                }
            case .router(.routeAction(id: .home, action: .home(.delegate(.searchBarTapped)))):
                return .send(.delegate(.searchBarTapped))
                
                
            case .parent(.resetToHome):
                state.routes.popToRoot()
                return .send(.router(.routeAction(id: .home, action: .home(.parent(.resetToHome)))))
            default:
                break;
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
