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
    case colorSettingView(AppColorSettingFeature)
    case creditView(CreditViewFeature)
    case meritFeature(MeritFeature)
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
        
        case parent(ParentAction)
        
        enum ParentAction {
            case resetToRoot
        }
    }
    
    var body: some ReducerOf<Self> {
        core()
    }
}

extension SettingCoordinator {
    private func core() -> some ReducerOf<Self> {
        Reduce{ state, action in
            switch action {
                /// APP Info 뷰 이동
            case .router(.routeAction(id: .root, action: .settingView(.delegate(.sendToAppInfo)))):
                state.routes.push(.appInfoView(AppInfoFeature.State()))
                
            case .router(.routeAction(id: .appInfo, action: .appInfoView(.delegate(.tapBackButton)))):
                state.routes.pop()
                
                /// App Color Setting View 이동
            case .router(.routeAction(id: .root, action: .settingView(.delegate(.selectedColorSettingCase)))):
                state.routes.push(.colorSettingView(AppColorSettingFeature.State()))
                
            case .router(.routeAction(id: .colorSetting, action: .colorSettingView(.delegate(.backButtonTapped)))):
                state.routes.pop()
                
                /// Credit View 이동
            case .router(.routeAction(id: .root, action: .settingView(.delegate(.sendToCredit)))):
                state.routes.push(.creditView(CreditViewFeature.State()))
            case .router(.routeAction(id: .credit, action: .creditView(.delegate(.backButtonTapped)))):
                state.routes.pop()
                
                /// 유공자 뷰 이동
            case let .router(.routeAction(id: .credit, action: .creditView(.delegate(.sendToMerit(item))))):
                state.routes.push(.meritFeature(MeritFeature.State(meritCase: item)))
                
            case .router(.routeAction(id: .merit, action: .meritFeature(.delegate(.backButtonTapped)))):
                state.routes.pop()
                
            case .parent(.resetToRoot):
                state.routes.popToRoot()
                
            default:
                break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
