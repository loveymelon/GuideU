//
//  SearchResultFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchResultFeature: GuideUReducer {
    
    @ObservableState
    struct State: Equatable {
        var searchResultEntity: SearchResultEntity? = nil
        let currentSearchKeyword: String
        let meanText = Const.mean
        let descriptionText = Const.explain
        let relatedText = Const.related
    }
    
    enum Action {
        case viewCycleType(ViewCycleType)
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        case delegate(Delegate)
        
        enum Delegate {
            case backButtonTapped
        }
    }
    
    enum ViewCycleType {
        case viewOnAppear
    }
    
    enum ViewEventType {
        case backButtonTapped
    }
    
    enum DataTransType {
        case searchDatas([SearchResultEntity])
        case errorInfo(String)
    }
    
    enum NetworkType {
        case fetchSearch
    }
    
    enum CancelId: Hashable {
        
    }
    
    @Dependency(\.searchRepository) var searchRepository
    
    var body: some ReducerOf<Self> {
        core()
    }
}

extension SearchResultFeature {
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewCycleType(.viewOnAppear):
                return .run { send in
                    print("onAppear")
                    await send(.networkType(.fetchSearch))
                }
                
            case .networkType(.fetchSearch):
                return .run { [state = state] send in
                    print("network")
                    let result = await searchRepository.fetchSearch(state.currentSearchKeyword)
                    
                    switch result {
                    case let .success(data):
//                        print(data)
                        await send(.dataTransType(.searchDatas(data)))
                    case let .failure(error):
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case let .dataTransType(.searchDatas(entitys)):
                guard let searchResult = entitys.first else { return .none }
                print(entitys[0].relatedVideos)
                print("result", state.searchResultEntity)
                state.searchResultEntity = searchResult
                print("result", state.searchResultEntity)
            case let .dataTransType(.errorInfo(error)):
                print(error)
                
            case .viewEventType(.backButtonTapped):
                return .send(.delegate(.backButtonTapped))
                
            default:
                break
            }
            return .none
        }
    }
}
