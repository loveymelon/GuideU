//
//  TabNavCoordinator.swift
//  GuideU
//
//  Created by 김진수 on 9/11/24.
//

import Foundation
import TCACoordinators
import ComposableArchitecture

@Reducer(state: .equatable)
enum TabNavSceen {
    case tab(TabCoordinator)
    case detail(PersonFeature)
}

@Reducer
struct TabNavCoordinator {
    
    @ObservableState
    struct State: Equatable {
        static let initialState = State(routes: [.root(.tab(TabCoordinator.State()), embedInNavigationView: true)])
        var routes: IdentifiedArrayOf<Route<TabNavSceen.State>>
    }
    
    enum Action {
        
        case router(IdentifiedRouterActionOf<TabNavSceen>)
        
        case viewLifeCycle(ViewLifeCycle)

        /// 상위뷰에게 전달
        case delegate(Delegate)
        
        enum Delegate {

        }
    }
    
    
    enum ViewLifeCycle {
        case background
            
        case inactive
            
        case active
        
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        core()
    }
}

extension TabNavCoordinator {
    
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .router(.routeAction(id: .tab, action: .tab(.delegate(.detailButtonTapped(identifier))))):
                state.routes.push(.detail(.init(identifierURL: Const.youtubeBaseString + identifier)))
                
            case .viewLifeCycle(.active):
                print("액티브")
                
                if let url = UserDefaultsManager.sharedURL {
                    state.routes.push(.detail(.init(identifierURL: url)))
                }
                
            case .viewLifeCycle(.onAppear):
                if let url = UserDefaultsManager.sharedURL {
                    state.routes.push(.detail(.init(identifierURL: url)))
                }
                
                
            case .router(.routeAction(id: .detail, action: .detail(.delegate(.backButtonTapped)))):
                state.routes.pop()
                
            default:
                break;
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
