//
//  SettingCoordinator.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/16/24.
//

import Foundation
import ComposableArchitecture
import TCACoordinators


@Reducer(state: .equatable)
enum SettingScreen {
    case settingView(SettingFeature)
}

@Reducer
struct SettingCoordinator {
    
    @ObservableState
    struct State: Equatable {
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
        Reduce{ State, Action in
            switch Action {
            default:
                break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
