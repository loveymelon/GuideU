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
    
    var body: some View {
        WithPerceptionTracking {
            
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
