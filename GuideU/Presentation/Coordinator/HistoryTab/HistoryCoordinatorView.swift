//
//  HistoryCoordinatorView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/13/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct HistoryCoordinatorView: View {
    
    @Perception.Bindable var store: StoreOf<HistoryCoordinator>
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .root(store):
                    HistoryView(store: store)
                        .environmentObject(colorSystem)
                        .toolbarBackground(colorSystem.color(colorCase: .tabbar).opacity(0.9), for: .navigationBar)
                }
            }
        }
    }
}

extension HistoryScreen.State: Identifiable {
    
    var id: ID {
        switch self {
        case .root:
            return .historyView
        }
    }
    
    enum ID {
        case historyView
    }
}
