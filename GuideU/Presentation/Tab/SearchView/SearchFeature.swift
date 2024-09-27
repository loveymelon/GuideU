//
//  SearchFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/2/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchFeature: GuideUReducer {
    
    @ObservableState
    struct State: Equatable {
        var currentText = ""
        var searchHistory: [String] = []
        var searchCaseList: [SuggestEntity] = []
        var isSearchResEmpty: Bool = false
        var backButtonHidden: Bool = true
        var popUpCase: popUpCase? = nil
        
        // Static Text
        let placeHolderText = Const.placeHolderText
        let navigationTitle = Const.navTitle
        let allClearText = Const.allClear
        let recentSectionText = Const.recentSection
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
            case openToResultView(suggestEntity: SuggestEntity)
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
        case searchResultTapped(SuggestEntity)
        case historyTapped(text: String)
    }
    
    enum DataTransType {
        case searchData([SuggestEntity])
        case errorInfo(String)
    }
    
    enum NetworkType {
        case search(String)
    }
    
    enum CancelId: Hashable {
        case searchID
    }
    
    @Dependency(\.searchRepository) var searchRepository
    @Dependency(\.realmRepository) var realmRepository
    
    var body: some ReducerOf<Self> {
        core()
    }
}

extension SearchFeature {
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                // MARK: View Cycle
            case .viewCycleType(.onAppear):
                /// Realm Search History
                state.searchHistory = realmRepository.fetch()
                
                // MARK: View Event
            case let .viewEventType(.deleteHistory(index)):
                let result = realmRepository.delete(keyworkd: state.searchHistory[index])
                
                switch result {
                case .success(_):
                    state.searchHistory.remove(at: index)
                    
                    state.popUpCase = .delete
                case .failure(let error):
                    return .send(.dataTransType(.errorInfo(error.description)))
                }
                
            case .viewEventType(.deleteAll):
                let result = realmRepository.deleteAll()
                state.popUpCase = .allDelete
                
                switch result {
                case .success():
                    state.searchHistory.removeAll()
                case .failure(let error):
                    return .send(.dataTransType(.errorInfo(error.description)))
                }
                
                
            case let .viewEventType(.onSubmit(text)):
                return .run { send in
                    await send(.networkType(.search(text)))
                }
                
            case let .viewEventType(.searchResultTapped(model)):
                let currentText = state.currentText.trimmingCharacters(in: .whitespaces)
                if !currentText.isEmpty {
                    
                    let result = realmRepository.searchCreate(history: model.keyWord)
                    
                    switch result {
                    case .success(_):
                        state.searchHistory = realmRepository.fetch()
                        state.currentText = ""
                        
                        return .run { send in
                            await send(.delegate(.openToResultView(suggestEntity: model)))
                        }
                    case .failure(let error):
                        return .send(.dataTransType(.errorInfo(error.description)))
                    }
                }
                
            case let .viewEventType(.historyTapped(text)):
                return.send(.currentText(text))
                
            case .viewEventType(.closeButtonTapped):
                return .run { send in
                    await send(.delegate(.closeButtonTapped))
                }
                
                // MARK: Network
            case let .networkType(.search(search)):
                return .run { send in
                    let result = await searchRepository.fetchSuggest(search)
                    
                    switch result {
                    case .success(let data):
                        await send(.dataTransType(.searchData(data)))
                    case .failure(let error):
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
                // MARK: DataTrans
            case let .dataTransType(.searchData(suggestEntity)):
                state.searchCaseList = suggestEntity
                state.isSearchResEmpty = state.searchCaseList.isEmpty
                
            case let .dataTransType(.errorInfo(error)):
                print(error)
                
                // MARK: Binding
            case let .currentText(text):
                if state.currentText == text { return .none }
                state.currentText = text
                state.isSearchResEmpty = false
                
                if !text.isEmpty {
                    return .run { send in
                        await send(.networkType(.search(text)))
                    }.debounce(id: CancelId.searchID, for: 1, scheduler: RunLoop.main)
                }
                
            case let .popUpCase(caseOf):
                state.popUpCase = caseOf
                
            default:
                break
            }
            
            return .none
        }
    }
}
