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
        case deleteHistory(index: Int)
    }
    
    enum DataTransType {
        
    }
    
    enum NetworkType {
        
    }
    
    enum CancelId: Hashable {
        
    }
    
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
                state.searchHistory = ["김진수", "바보"]
                state.searchCaseList = [
                    .init(type: .character, keyWord: "우왁굳"),
                    .init(type: .meme, keyWord: "우리왁굳끼리"),
                    .init(type: .meme, keyWord: "우정촌"),
                    .init(type: .meme, keyWord: "우왁배드"),
                    .init(type: .meme, keyWord: "우마뾰이 전설")
                ]
                // MARK: View Event
            case let .viewEventType(.deleteHistory(index)):
                state.searchHistory.remove(at: index)
                
                /// Realm Delete 하셈
                
                // MARK: Binding
            case let .currentText(text):
                state.currentText = text
                
                
                
            default:
                break
            }
            
            return .none
        }
    }
}
