//
//  RootCoordinatorView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators


struct RootCoordinatorView: View {
    
    @Perception.Bindable var store: StoreOf<RootCoordinator>
    /// Swift UI 적인 방법
    @Environment(\.scenePhase) var phase
    
    var body: some View {
        WithPerceptionTracking {
            Group {
                switch store.viewState {
                case .start:
                    
                    TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                        switch screen.case {
                        case let .splash(store):
                            SplashView(store: store)
                        case let .onboardPage(store):
                            OnBoardPageView(store: store)
                        }
                    }
                    
                case .tab:
                    IfLetStore(store.scope(state: \.currentTabCoordinator, action: \.tabCoordinatorAction)) { store in
                        GuideUTabView(store: store)
                    }
                }
            }
            .onChange(of: phase) { newValue in
                switch newValue {
                case .background:
                    store.send(.viewLifeCycle(.background))
                case .inactive:
                    store.send(.viewLifeCycle(.inactive))
                case .active:
                    store.send(.viewLifeCycle(.active))
                @unknown default:
                    break
                }
            }
        }
    }
}



extension RootScreen.State: Identifiable {
    
    var id: ID {
        switch self {
        case .splash:
            return .splash
        case .onboardPage:
            return .onboardPage
        }
    }
    
    enum ID: Identifiable {
        case splash
        case onboardPage
        
        var id: ID {
            return self
        }
    }
    
}
