//
//  SettingCoordinator.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/16/24.
//

import Foundation
import ComposableArchitecture
@preconcurrency import TCACoordinators


@Reducer(state: .equatable)
enum SettingScreen {
    case settingView(SettingFeature)
    case appInfoView(AppInfoFeature)
}

@Reducer
struct SettingCoordinator {
    
    @ObservableState
    struct State: Equatable, Sendable {
        static let initialState = Self(routes: [.root(.settingView(SettingFeature.State()), embedInNavigationView: true)])
        var routes: IdentifiedArrayOf<Route<SettingScreen.State>>
    }
    
    enum Action {
        case router(IdentifiedRouterActionOf<SettingScreen>)
    }
    
    var body: some ReducerOf<Self> {
        core()
    }
}

extension SettingCoordinator {
    private func core() -> some ReducerOf<Self> {
        Reduce{ state, action in
            switch action {
                
            case .router(.routeAction(id: .root, action: .settingView(.delegate(.sendToAppInfo)))):
                state.routes.push(.appInfoView(AppInfoFeature.State()))
                
            case .router(.routeAction(id: .appInfo, action: .appInfoView(.delegate(.tapBackButton)))):
                state.routes.pop()
                
            default:
                break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
