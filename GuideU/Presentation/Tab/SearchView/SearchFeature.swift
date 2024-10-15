//
//  SearchFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/2/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchFeature: GuideUReducer, GuideUReducerOptional {
    
    @ObservableState
    struct State: Equatable {
        var currentText = ""
        var searchHistory: [String] = []
        var searchCaseList: [SuggestEntity] = []
        var searchResult: [SearchResultEntity] = []
        var viewCase: SearchViewType = SearchViewType.searchHistoryMode
        var backButtonHidden: Bool = true
        var popUpCase: popUpCase? = nil
        
        // Static Text
        let placeHolderText = Const.placeHolderText
        let navigationTitle = Const.navTitle
        let allClearText = Const.allClear
        let recentSectionText = Const.recentSection
    }
    
    enum SearchViewType {
        case searchHistoryMode
        case suggestMode
        case resultListMode
        case noResultMode
    }
    
    enum popUpCase {
        case allDelete
        case delete
        var message: String {
            switch self {
            case .allDelete:
                return Const.allDeleteMent
            case .delete:
                return Const.deleteMent
            }
        }
        
        var title: String { return "삭제"}
    }
    
    enum Action {
        case viewCycleType(ViewCycleType)
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        
        /// Binding
        case currentText(String)
        case delegate(Delegate)
        case popUpCase(popUpCase?)
        enum Delegate {
            case closeButtonTapped
            case openToResultView(searchResultEntity: SearchResultEntity)
        }
        
        case parent(ParentAction)
        
        enum ParentAction {
            case resetToSearchView
        }
    }
    
    
    enum ViewCycleType {
        case onAppear
    }
    
    enum ViewEventType {
        case onSubmit(String)
        case deleteHistory(index: Int)
        case deleteAll
        case closeButtonTapped
        case suggestResultTapped(SuggestEntity)
        case searchResultTapped(SearchResultEntity)
        case historyTapped(text: String)
    }
    
    enum DataTransType {
        case searchData([SuggestEntity])
        case searchResultData([SearchResultEntity])
        case errorInfo(Error)
        case realmFetch
        case realmSuccess([String])
        case removeRealm(Int)
        case removeAllRealm
    }
    
    enum NetworkType {
        case searchSuggest(String)
        case searchResult(String)
    }
    
    enum CancelId: Hashable {
        case searchID
    }
    
    private let dataSourceActor = DataSourceActor()
    
    @Dependency(\.searchRepository) var searchRepository
    
    var body: some ReducerOf<Self> {
        core()
    }
}

extension SearchFeature {
    private func core() -> some ReducerOf<Self> {
        Reduce {
            state,
            action in
            switch action {
                // MARK: View Cycle
            case .viewCycleType(.onAppear):
                /// Realm Search History
                return .send(.dataTransType(.realmFetch))
                
                // MARK: View Event
            case let .viewEventType(.deleteHistory(index)):
                return .run {[state = state] send in
                    do {
                        try await dataSourceActor.delete(keyworkd: state.searchHistory[index])
                        
                        await send(.dataTransType(.removeRealm(index)))
                    } catch {
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case let .dataTransType(.removeRealm(index)):
                state.searchHistory.remove(at: index)
                state.popUpCase = .delete
                
            case .viewEventType(.deleteAll):
                return .run { send in
                    do {
                        try await dataSourceActor.deleteAll()
                        
                        await send(.dataTransType(.removeAllRealm))
                    } catch {
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case let .viewEventType(.onSubmit(text)):
                return .concatenate(
                    [
                        .cancel(
                            id: CancelId.searchID
                        ),
                        .run(
                            operation: { send in
                                await send(
                                    .networkType(
                                        .searchResult(
                                            text
                                        )
                                    )
                                )
                            })
                    ]
                )
                
            case let .viewEventType(.suggestResultTapped(model)):
                let currentText = state.currentText.trimmingCharacters(in: .whitespaces)
                if !currentText.isEmpty {
                    
                    state.currentText = model.keyWord
                    
                    return .run { send in
                        await send(.networkType(.searchResult(model.keyWord)))
                    }
                }
                
            case let .viewEventType(.searchResultTapped(model)):
                return .run { send in
                    do {
                        try await dataSourceActor.searchCreate(history: model.name)
                        
                        await send(.dataTransType(.realmFetch))
                        await send(.delegate(.openToResultView(searchResultEntity: model)))
                    } catch {
                        await send(.dataTransType(.errorInfo(error)))
                    }
                    
                }
                
            case let .viewEventType(.historyTapped(text)):
                return.send(.currentText(text))
                
            case .viewEventType(.closeButtonTapped):
                return .run { send in
                    await send(.delegate(.closeButtonTapped))
                }
                
                // MARK: Network
            case let .networkType(.searchSuggest(search)):
                return .run { send in
                    do {
                        let data = try await searchRepository.fetchSuggest(search)
                        
                        await send(.dataTransType(.searchData(data)))
                    } catch {
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case let .networkType(.searchResult(text)):
                return .run { send in
                    do {
                        let data = try await searchRepository.fetchSearchResults(text)
                        
                        await send(.dataTransType(.searchResultData(data)))
                    } catch {
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
                // MARK: DataTrans
            case let .dataTransType(.searchData(suggestEntity)):
                state.searchCaseList = suggestEntity
                
            case let .dataTransType(.errorInfo(error)):
                print(errorHandling(error))
                
            case .dataTransType(.realmFetch):
                return .run { send in
                    let result = await dataSourceActor.fetch()
                    await send(.dataTransType(.realmSuccess(result)))
                }
                
            case let .dataTransType(.realmSuccess(texts)):
                state.searchHistory = texts
                
            case .dataTransType(.removeAllRealm):
                state.popUpCase = .allDelete
                state.searchHistory.removeAll()
                
            case let .dataTransType(.searchResultData(datas)):
                state.searchResult = datas
                state.viewCase = datas.isEmpty ? .noResultMode : .resultListMode
                
                // MARK: Binding
            case let .currentText(text):
                return currentTextTester(text: text, state: &state)
                
            case let .popUpCase(caseOf):
                state.popUpCase = caseOf
                
                
            case .parent(.resetToSearchView):
                resetList(state: &state)
                state.currentText = ""
                state.viewCase = .searchHistoryMode
                
            default:
                break
            }
            
            return .none
        }
    }
}

extension SearchFeature {
    private func currentTextTester(text: String, state: inout State) -> Effect<Action>  {
        if state.currentText == text { return .none }
        state.currentText = text
        
        resetList(state: &state)
        
        if text != "" {
            state.viewCase = .suggestMode
            
            return .run { send in
                await send(.networkType(.searchSuggest(text)))
            }
            .debounce(id: CancelId.searchID, for: 1, scheduler: RunLoop.main)
        } else {
            state.viewCase = .searchHistoryMode
            return .cancel(id: CancelId.searchID)
        }
    }
    
    private func resetList(state: inout State) {
        state.searchResult = []
        state.searchCaseList = []
    }
}
