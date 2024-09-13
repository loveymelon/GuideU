//
//  SearchResultView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/13/24.
//

import SwiftUI
import ComposableArchitecture

struct SearchResultView: View {
    
    @Perception.Bindable var store: StoreOf<SearchResultFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                
            }
        }
    }
}

#if DEBUG
#Preview {
    SearchResultView(store: Store(initialState: SearchResultFeature.State(currentSearchKeyword: "우왁굳"), reducer: {
        SearchResultFeature()
    }))
}

#endif
