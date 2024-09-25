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
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        WithPerceptionTracking {
            contentView()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(store.navigationTitle)
                            .font(Font(WantedFont.semiFont.font(size: 20)))
                            .foregroundStyle(colorSystem.color(colorCase: .textColor))
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
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
                        .listRowBackground(colorSystem.color(colorCase: .background))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
        }
        .background(colorSystem.color(colorCase: .background))
    }
}

#if DEBUG
#Preview {
    SettingView(store: Store(initialState: SettingFeature.State(), reducer: {
        SettingFeature()
    }))
}
#endif
