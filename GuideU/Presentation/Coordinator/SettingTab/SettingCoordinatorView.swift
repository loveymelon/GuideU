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
                case let .appInfoView(store):
                    AppInfoView(store: store)
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
        }
    }
    
    enum ID {
        case root
        case appInfo
    }
}
