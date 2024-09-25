//
//  SearchCoordinatorView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/11/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct SearchCoordinatorView: View {
    
    @Perception.Bindable var store: StoreOf<SearchCoordinator>
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .search(store):
                    SearchView(store: store)
                        .environmentObject(colorSystem)
                case let .searchResult(store):
                    SearchResultView(store: store)
                        .environmentObject(colorSystem)
                }
            }
        }
    }
}



extension SearchScreen.State: Identifiable {
    var id: ID {
        switch self {
        case .search:
            return .search
        case .searchResult:
            return .searchResult
        }
    }
    
    enum ID {
        case search
        case searchResult
        
        var id: ID {
            return self
        }
    }
}
