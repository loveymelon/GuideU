//
//  SettingView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/16/24.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    
    @Perception.Bindable var store: StoreOf<SettingFeature>
    
    var body: some View {
        WithPerceptionTracking {
            contentView()
        }
    }
}
// MARK: ContentView MAIN
extension SettingView {
    private func contentView() -> some View {
        VStack{
            List {
                ForEach(SettingCase.allCases, id: \.self) { caseOf in
                    SettingListCellView(setModel: caseOf)
                        .asButton {
                            store.send(.viewEventType(.selectedSettingCase(caseOf)))
                        }
                        .padding(.vertical, 10)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle(store.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .scrollDisabled(true)
        }
    }
}

#if DEBUG
#Preview {
    SettingView(store: Store(initialState: SettingFeature.State(), reducer: {
        SettingFeature()
    }))
}
#endif
