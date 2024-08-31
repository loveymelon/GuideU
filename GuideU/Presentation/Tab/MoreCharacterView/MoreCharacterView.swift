//
//  MoreCharacterView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/28/24.
//

import SwiftUI
import ComposableArchitecture

struct MoreCharacterView: View {
    
    @Perception.Bindable var store: StoreOf<MoreCharacterFeature>

    var body: some View {
        WithPerceptionTracking {
            VStack {
                GuideUSearchBarView(currentText: $store.currentText.sending(\.currentText), placeHolder: store.constViewState.placeHolder, lineWidth: 1.4) {
                    store.send(.viewEventType(.onSubmit))
                }
                .onTapGesture {
                    /// View Changed
                    
                }
                .padding(.horizontal, 10)
                
                contentView()
                    .onAppear {
                        store.send(.viewCycleType(.onAppear))
                    }
            }
        }
    }
}

extension MoreCharacterView {
    private func contentView() -> some View {
        ScrollView {
            
            ZStack(alignment: .top) {
                ZStack {
                    Group {
                        if store.state.videoInfos.isEmpty {
                            ProgressView()
                        } else {
                            listContentView()
                        }
                    }
                    .padding(.top, 130)
                }
                ZStack {
                    wantMoreInfoView()
                        .padding(.top, 20)
                        .padding(.vertical, 4)
                }
                .zIndex(100)
            }
            
        }
        .background(Color(GuideUColor.ViewBaseColor.light.backColor))
    }
    
    private func listContentView() -> some View {
        LazyVStack {
            ForEach(Array(store.videoInfos.enumerated()), id: \.element.self) { index, data in
                MoreCharacterListView(setModel: data)
                    .asButton { // 선택되었을때
                        print(data)
                    }
                    .onAppear {
                        store.send(.viewEventType(.videoOnAppear(index)))
                    }
                    .padding(.bottom, 10)
            }
        }
        .padding(.horizontal, 12)
    }
    
    private func wantMoreInfoView() -> some View {
        VStack(spacing: 0) {
            Text(
                store.constViewState.main.styledText(
                    fullFont: WantedFont.regularFont.font(size: 22),
                    fullColor: .black,
                    targetString: store.constViewState.targetString,
                    targetFont: WantedFont.boldFont.font(size: 24),
                    targetColor: GuideUColor.ViewBaseColor.light.primary
                )
            )
            
            HStack(alignment: .top, spacing: 4) {
                DropDownMenu(options: store.dropDownOptions.map({ $0.name }), selectedOptionIndex: $store.currentIndex.sending(\.currentIndex))
                    .frame(width: 110)
                    .zIndex(100)
                
                Text(store.constViewState.sub)
                    .font(Font(WantedFont.regularFont.font(size: 22)))
                    .padding(.top, 10)
            }
            
        }
    }
}
#if DEBUG
#Preview {
    MoreCharacterView(store: Store(initialState: MoreCharacterFeature.State(), reducer: {
        MoreCharacterFeature()
    }))
}
#endif

