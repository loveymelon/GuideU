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
    
    @StateObject private var colorSystem = ColorSystem()
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
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
                    TabNavCoordinatorView(store: store.scope(state: \.tabNavCoordinator, action: \.tabNavCoordinatorAction))
                        .environmentObject(colorSystem)
                }
            }
            .onAppear {
                store.send(.viewCycle(.onAppear))
            }
            .errorAlert(alertModel: $store.alertMessage.sending(\.bindingMessage), confirm: { item in
                store.send(.alertAction(.checkAlert(item)))
            }, cancel: { item in
                store.send(.alertAction(.cancelAlert(item)))
            })
            .background(colorSystem.color(colorCase: .tabbar))
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

#Preview {
    RootCoordinatorView(store: Store(initialState: RootCoordinator.State.initialState, reducer: {
        RootCoordinator()
    }))
}
