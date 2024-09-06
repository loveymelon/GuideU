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
            if store.searchState == nil {
                VStack {
                    fakeSearchBar()
                        .padding(.horizontal, 10)
                    .onTapGesture {
                        /// View Changed
                        store.send(.viewEventType(.searchViewChanged))
                    }
                    .padding(.horizontal, 10)
                    
                    contentView()
                        .onAppear {
                            store.send(.viewCycleType(.onAppear))
                        }
                }
                .sheet(item: $store.seletedVideo.sending(\.selectedVideo)) { data in
                    WKWebHosting(url: data.videoURL)
                }
            } else {
                IfLetStore(store.scope(state: \.searchState, action: \.searchAction)) { store in
                    SearchView(store: store)
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
                        store.send(.viewEventType(.selectedVideoIndex(index)))
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
    
    private func fakeSearchBar() -> some View {
        VStack {
            HStack {
                Text(store.constViewState.placeHolder)
                    .font(Font(WantedFont.regularFont.font(size: 15)))
                    .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.gray2))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.all, 12)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color(GuideUColor.ViewBaseColor.light.primary), lineWidth: 1.4)
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

