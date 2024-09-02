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
    struct State {
        var currentText = ""
        var searchHistory: [String] = []
        var searchCaseList: [SuggestEntity] = []
        
        // Static Text
        let placeHolderText = Const.placeHolderText
        let navigationTitle = Const.navTitle
        let allClearText = Const.allClear
        let recentSectionText = Const.recentSection
    }
    
    enum Action {
        case viewCycleType(ViewCycleType)
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        
        /// Binding
        case currentText(String)
        case delegate(Delegate)
        enum Delegate {
            
        }
    }
    
    
    enum ViewCycleType {
        case onAppear
    }
    
    enum ViewEventType {
        case onSubmit
        case deleteHistory(index: Int)
        case deleteAll
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
                case .failure(let error):
                    return .send(.dataTransType(.errorInfo(error.description)))
                }
                
            case .viewEventType(.onSubmit):
                if !state.currentText.trimmingCharacters(in: .whitespaces).isEmpty {
                    
                    let result = realmRepository.create(history: state.currentText)
                    
                    switch result {
                    case .success(_):
                        state.searchHistory = realmRepository.fetch()
                        state.currentText = ""
                    case .failure(let error):
                        return .send(.dataTransType(.errorInfo(error.description)))
                    }
                }
                
            case .viewEventType(.deleteAll):
                let result = realmRepository.deleteAll()
                
                switch result {
                case .success():
                    state.searchHistory.removeAll()
                case .failure(let error):
                    return .send(.dataTransType(.errorInfo(error.description)))
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
                
            case let .dataTransType(.errorInfo(error)):
                print(error)
                
                // MARK: Binding
            case let .currentText(text):
                state.currentText = text
                
                return .run { send in
                    await send(.networkType(.search(text)))
                }.debounce(id: CancelId.searchID, for: 1, scheduler: RunLoop.main)
                
            default:
                break
            }
            
            return .none
        }
    }
}
