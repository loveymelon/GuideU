//
//  SettingView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/16/24.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    
//    @Perception.Bindable var store: StoreOf<
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
                            
                        }
                        .padding(.vertical, 10)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("설정")
        }
    }
}

#if DEBUG
#Preview {
    SettingView()
}
#endif
