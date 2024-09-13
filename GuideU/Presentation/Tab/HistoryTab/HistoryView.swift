//
//  HistoryView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/13/24.
//

import SwiftUI
import ComposableArchitecture


struct HistoryView: View {
    
    @Perception.Bindable var store: StoreOf<HistoryFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Text("김진수 섹스 ")
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("최근 알아본")
            .onAppear {
                store.send(.viewCycleType(.viewOnAppear))
            }
            .onChange(of: store.videosEntity) { newValue in
                print(newValue)
            }
        }
    }
}

