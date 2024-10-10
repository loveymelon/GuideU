//
//  HistoryCoordinator.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/13/24.
//

import Foundation
import ComposableArchitecture
@preconcurrency import TCACoordinators


@Reducer(state: .equatable)
enum HistoryScreen {
    case root(HistoryFeature)
}

@Reducer
struct HistoryCoordinator {
    @ObservableState
    struct State: Equatable, Sendable {
        static let initialState = Self(routes: [.root(.root(HistoryFeature.State()), embedInNavigationView: true)])
        var routes: IdentifiedArrayOf<Route<HistoryScreen.State>>
    }
    
    enum Action {
        case router(IdentifiedRouterActionOf<HistoryScreen>)
        
        case delegate(Delegate)
        case parent(ParentAction)
        
        enum Delegate {
            case detailButtonTapped(String)
        }
        
        enum ParentAction {
            case resetToHistory
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
                
            case .parent(.resetToHistory):
                state.routes.popToRoot()
                return .send(.router(.routeAction(id: .historyView, action: .root(.parent(.resetToHistory)))))
                
            default:
                break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
