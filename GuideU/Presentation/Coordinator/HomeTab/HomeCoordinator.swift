//
//  HomeCoordinator.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/26/24.
//

import Foundation
import ComposableArchitecture
import TCACoordinators


@Reducer(state: .equatable)
enum HomeScreen {
    case home(MoreCharacterFeature)
}

@Reducer
struct HomeCoordinator {
    
    @ObservableState
    struct State: Equatable {
        static let initialState = State(routes: [.root(.home(MoreCharacterFeature.State()), embedInNavigationView: true)])
        var routes: IdentifiedArrayOf<Route<HomeScreen.State>>
    }
    
    enum Action {
        
        case router(IdentifiedRouterActionOf<HomeScreen>)
        
        /// 상위뷰에게 전달
        case delegate(Delegate)
        
        enum Delegate {
            case detailButtonTapped(String)
            case searchBarTapped
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
            default:
                break;
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
