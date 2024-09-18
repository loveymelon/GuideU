//
//  HistoryCoordinator.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/13/24.
//

import Foundation
import ComposableArchitecture
import TCACoordinators


@Reducer(state: .equatable)
enum HistoryScreen {
    case root(HistoryFeature)
}

@Reducer
struct HistoryCoordinator {
    @ObservableState
    struct State: Equatable {
        static let initialState = Self(routes: [.root(.root(HistoryFeature.State()), embedInNavigationView: true)])
        var routes: IdentifiedArrayOf<Route<HistoryScreen.State>>
    }
    
    enum Action {
        case router(IdentifiedRouterActionOf<HistoryScreen>)
        
        case delegate(Delegate)
        
        enum Delegate {
            case detailButtonTapped(String)
        }
    }
    
    var body: some ReducerOf<Self> {
        core()
    }
}

extension HistoryCoordinator {
    
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .router(.routeAction(id: .historyView, action: .root(.delegate(.detailButtonTapped(identifier))))):
                return .run { send in
                    await send(.delegate(.detailButtonTapped(identifier)))
                }
                
            default:
                break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
