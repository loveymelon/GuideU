//
//  SettingCoordinatorView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/16/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct SettingCoordinatorView: View {
    
    @Perception.Bindable var store: StoreOf<SettingCoordinator>
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .settingView(store):
                    SettingView(store: store)
                        .environmentObject(colorSystem)
                        .toolbarBackground(colorSystem.color(colorCase: .tabbar).opacity(0.9), for: .navigationBar)
                case let .appInfoView(store):
                    AppInfoView(store: store)
                        .environmentObject(colorSystem)
                        .toolbarBackground(colorSystem.color(colorCase: .tabbar).opacity(0.9), for: .navigationBar)
                case let .colorSettingView(store):
                    AppColorSettingView(store: store)
                        .environmentObject(colorSystem)
                        .toolbarBackground(colorSystem.color(colorCase: .tabbar).opacity(0.9), for: .navigationBar)
                    
                case let .creditView(store):
                    CreditView(store: store)
                        .environmentObject(colorSystem)
                        .toolbarBackground(colorSystem.color(colorCase: .tabbar).opacity(0.9), for: .navigationBar)
                }
            }
        }
    }
}

extension SettingScreen.State: Identifiable {
    var id: ID {
        switch self {
        case .settingView:
            return .root
        case .appInfoView:
            return .appInfo
        case .colorSettingView:
            return .colorSetting
        case .creditView:
            return .credit
        }
    }
    
    enum ID {
        case root
        case appInfo
        case colorSetting
        case credit
    }
}
