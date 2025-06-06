//
//  MorePersonCoordinator.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/9/24.
//

import Foundation
import ComposableArchitecture
@preconcurrency import TCACoordinators


@Reducer(state: .equatable)
enum MorePersonScreen {
    case home(PersonFeature)
}

@Reducer
struct MorePersonCoordinator {
    
    @ObservableState
    struct State: Equatable, Sendable {
        static let initialState = State(routes: [.root(.home(PersonFeature.State(identifierURL: "")), embedInNavigationView: true)])
        var routes: IdentifiedArrayOf<Route<MorePersonScreen.State>>
    }
    
    enum Action {
        case router(IdentifiedRouterActionOf<MorePersonScreen>)
        
        /// 상위뷰에게 전달
        case delegate(Delegate)
        
        enum Delegate {
            case homeViewBackButtonTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        core()
    }
}

extension MorePersonCoordinator {
    
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .router(.routeAction(id: _, action: .home(.delegate(.backButtonTapped)))):
                return .send(.delegate(.homeViewBackButtonTapped))
                
            default:
                break;
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
