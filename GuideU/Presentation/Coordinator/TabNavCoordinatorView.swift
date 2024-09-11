//
//  TabNavCoordinatorView.swift
//  GuideU
//
//  Created by 김진수 on 9/11/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct TabNavCoordinatorView: View {
    @Perception.Bindable var store: StoreOf<TabNavCoordinator>
    
    /// Swift UI 적인 방법
    @Environment(\.scenePhase) var phase
    
    var body: some View {
        WithPerceptionTracking {
            Group {
                TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                    switch screen.case {
                    case let .tab(store):
                        GuideUTabView(store: store)
                    case let .detail(store):
                        MorePersonView(store: store)
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
            .onAppear {
                store.send(.viewLifeCycle(.onAppear))
            }
        }
    }
}

extension TabNavSceen.State: Identifiable {
    
    var id: ID {
        switch self {
        case .tab:
            return .tab
        case .detail:
            return .detail
        }
    }
    
    enum ID: Identifiable {
        case tab
        case detail
        
        var id: ID {
            return self
        }
    }
    
}
