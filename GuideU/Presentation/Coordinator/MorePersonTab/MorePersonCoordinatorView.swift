//
//  MorePersonCoordinatorView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/9/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct MorePersonCoordinatorView: View {
    
    @Perception.Bindable var store: StoreOf<MorePersonCoordinator>
    /// Swift UI 적인 방법
    @Environment(\.scenePhase) var phase
    
    var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .home(store):
                    MorePersonView(store: store)
                }
            }
        }
    }
}



extension MorePersonScreen.State: Identifiable {
    
    var id: ID {
        switch self {
        case .home:
            return .home
        }
    }
    
    enum ID: Identifiable {
        case home
        
        var id: ID {
            return self
        }
    }
    
}
