//
//  SearchView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/31/24.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    
    @Perception.Bindable var store: StoreOf<SearchFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                fakeNavigation()
                    .padding(.horizontal, 10)
                
                if store.currentText.isEmpty {
                    currentListView()
                } else {
                    searchListView()
                }
            }
            .onAppear {
                store.send(.viewCycleType(.onAppear))
            }
        }
    }
}

// MARK: 검색중인 텍스트가 존재하지 않았을때
extension SearchView {
    
    private func currentListView() -> some View {
        ScrollView {
            recentSectionView()
                .padding(.horizontal, 10)
                .padding(.top, 10)
            ForEach(Array(store.searchHistory.enumerated()), id: \.element.self) { index, text in
                SearchHistoryCellView(name: text) {
                    /// RemoveButtonTapped
                    store.send(.viewEventType(.deleteHistory(index: index)))
                }
                    .padding(.trailing, 10)
                    .padding(.leading, 8)
            }
        }
    }
}
// MARK: 검색중인 텍스트가 존재할 경우
extension SearchView {
    private func searchListView() -> some View {
        ScrollView {
            ForEach(store.searchCaseList, id: \.self) { model in
                SearchResultCaseView(
                    currentText: store.currentText,
                    setModel: model
                )
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            }
        }
    }
}

// MARK: 최근 검색한 | 전체삭제
extension SearchView {
    private func recentSectionView() -> some View {
        HStack(alignment: .center) {
            Group {
                Text(store.recentSectionText)
                    .font(Font(WantedFont.midFont.font(size: 15)))
                    
                Text("|")
                    .font(Font(WantedFont.midFont.font(size: 13)))
                    .offset(y: -1.5)
                Text(store.allClearText)
                    .font(Font(WantedFont.midFont.font(size: 15)))
                    .asButton {
                        store.send(.viewEventType(.deleteAll))
                    }
            }
            .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.gray2))
            Spacer()
        }
    }
}

// MARK: 상단 네비게이션
extension SearchView {
    private func fakeNavigation()  -> some View {
        VStack {
            HStack {
                Image.appLogo
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 52)
                
                Spacer()
                
                Text(store.navigationTitle)
                    .font(Font(WantedFont.midFont.font(size: 17)))
                
                Spacer()
                VStack {
                    Image.close
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .asButton {
                            store.send(.viewEventType(.closeButtonTapped))
                        }
                        .frame(height: 32)
                }
                .frame(width: 52)
            }
            GuidUSearchBarBottomLineView(currentText: $store.currentText.sending(\.currentText), placeHolder: store.placeHolderText, lineWidth: 1.4) {
                /// onSubmit
                store.send(.viewEventType(.onSubmit))
            }
        }
    }
}


#if DEBUG
#Preview {
    SearchView(store: Store(initialState: SearchFeature.State(), reducer: {
        SearchFeature()
    }))
}
#endif
