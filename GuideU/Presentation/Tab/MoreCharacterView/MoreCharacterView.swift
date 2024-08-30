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
        WithPerceptionTracking{
            contentView()
                .onAppear {
                    store.send(.viewCycleType(.onAppear))
                }
        }
    }
}

extension MoreCharacterView {
    private func contentView() -> some View {
        VStack {
            GuideUSearchBarView(currentText: $store.currentText.sending(\.currentText), placeHolder: store.constViewState.placeHolder, lineWidth: 1.4) {
                store.send(.viewEventType(.onSubmit))
            }
            .padding(.horizontal, 10)
            ScrollView {
                ZStack(alignment: .top) {
                    wantMoreInfoView()
                        .padding(.top, 5)
                        .padding(.vertical, 10)
                    VStack {
                        ForEach(Array(store.videoInfos.enumerated()), id: \.element.self) { index, data in
                            Text(String(index))
                            // appendConstentOff
                                .onAppear {
                                    store.send(.viewEventType(.videoOnAppear(index)))
                                }
                        }
                    }
                    .padding(.top, 130)
                }
            }
            .scrollDisabled(false)
        }
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
            
            HStack( alignment: .top) {
                DropDownMenu(options: store.dropDownOptions.map({ $0.name }), selectedOptionIndex: $store.currentIndex.sending(\.currentIndex))
                    .frame(width: 130)
                
                Text(store.constViewState.sub)
                    .font(Font(WantedFont.semiFont.font(size: 22)))
                    .padding(.top, 10)
            }
        }
    }
}

//#if DEBUG
//#Preview {
//    MoreCharacterView(store: Store(initialState: MoreCharacterFeature.State(), reducer: {
//        MoreCharacterFeature()
//    }))
//}
//#endif
