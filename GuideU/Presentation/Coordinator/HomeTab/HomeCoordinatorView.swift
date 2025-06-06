//
//  HomeCoordinatorView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/26/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct HomeCoordinatorView: View {
    
    @Perception.Bindable var store: StoreOf<HomeCoordinator>
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .home(store):
                    MoreCharacterView(store: store)
                        .environmentObject(colorSystem)
                        .toolbarBackground(colorSystem.color(colorCase: .tabbar).opacity(0.4), for: .navigationBar)
                }
            }
        }
    }
}

extension HomeScreen.State: Identifiable {
    
    var id: ID {
        switch self {
        case .home:
            return ID.home
        }
    }

    enum ID: Identifiable {
        case home
        
        var id: ID {
            return self
        }
    }
}
