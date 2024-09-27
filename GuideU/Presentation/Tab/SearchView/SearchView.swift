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
    @EnvironmentObject var colorSystem: ColorSystem
    
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
            .background(colorSystem.color(colorCase: .background))
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
                .environmentObject(colorSystem)
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
            .environmentObject(colorSystem)
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .asButton {
                store.send(.viewEventType(.searchResultTapped(model)))
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
            .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
            Spacer()
        }
    }
}

// MARK: 상단 네비게이션
extension SearchView {
    private func fakeNavigation()  -> some View {
        VStack {
            HStack {
                Spacer()
                
                Text(store.navigationTitle)
                    .font(Font(WantedFont.semiFont.font(size: 20)))
                    .frame(height: 52)
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                Spacer()
            }
            
            
            GuidUSearchBarBottomLineView(currentText: $store.currentText.sending(\.currentText), placeHolder: store.placeHolderText, lineWidth: 1.4) {
                store.send(.viewEventType(.onSubmit(store.currentText)))
            }
            .foregroundStyle(colorSystem.color(colorCase: .textColor))
            .environmentObject(colorSystem)
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
                        .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
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
