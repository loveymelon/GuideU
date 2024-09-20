//
//  SearchView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/31/24.
//

import SwiftUI
import ComposableArchitecture
import PopupView

struct SearchView: View {
    
    @Perception.Bindable var store: StoreOf<SearchFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                fakeNavigation()
                    .padding(.horizontal, 10)
                ScrollView {
                    if store.currentText.isEmpty {
                        currentListView()
                    } else {
                        if store.isSearchResEmpty {
                            noResultView()
                        } else {
                            searchListView()
                        }
                    }
                }
                .scrollDismissesKeyboard(.immediately)
            }
            .onAppear {
                store.send(.viewCycleType(.onAppear))
            }
            .popup(item: $store.popUpCase.sending(\.popUpCase)) { caseOf in
                BottomPopView(detail: caseOf.message, backColor: .white)
            } customize: {
                $0
                    .type(.floater())
                    .position(.top)
                    .animation(.spring())
                    .autohideIn(1.5)
            }
        }
    }
}

// MARK: 검색중인 텍스트가 존재하지 않았을때
extension SearchView {
    
    private func currentListView() -> some View {
        VStack {
            recentSectionView()
                .padding(.horizontal, 10)
                .padding(.top, 10)
            ForEach(Array(store.searchHistory.enumerated()), id: \.element.self) { index, text in
                SearchHistoryCellView(name: text) {
                    /// RemoveButtonTapped
                    store.send(.viewEventType(.deleteHistory(index: index)))
                }
                .asButton {
                    store.send(.viewEventType(.historyTapped(text: text)))
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
        
        ForEach(store.searchCaseList, id: \.self) { model in
            SearchResultCaseView(
                currentText: store.currentText,
                setModel: model
            )
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .asButton {
                store.send(.viewEventType(.searchResultTapped(model.keyWord)))
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
                if !store.backButtonHidden {
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
                } else {
                    Color.clear
                        .frame(width: 52, height: 52)
                }
            }
            GuidUSearchBarBottomLineView(currentText: $store.currentText.sending(\.currentText), placeHolder: store.placeHolderText, lineWidth: 1.4) {
                /// onSubmit
                store.send(.viewEventType(.onSubmit(store.currentText)))
            }
        }
    }
    
    private func noResultView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("'\(store.currentText)' " + Const.noResultMent)
                    .lineLimit(3)
                    .font(Font(WantedFont.semiFont.font(size: 22)))
                    .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.Interaction1))
                Spacer()
            }
            .padding(.vertical, 10)
            
            VStack(alignment: .leading, spacing: 7) {
                ForEach(Const.noResultReason.allCases, id: \.self) { caseOf in
                    Text(caseOf.text)
                        .font(Font(WantedFont.regularFont.font(size: 14)))
                        .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.gray2))
                }
            }
            Spacer()
        }
        .padding(.horizontal, 10)
    }
}

#if DEBUG
#Preview {
    SearchView(store: Store(initialState: SearchFeature.State(), reducer: {
        SearchFeature()
    }))
}
#endif
