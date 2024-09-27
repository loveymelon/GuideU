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
        var searchResultEntity: SearchResultEntity = SearchResultEntity()
        let currentSearchKeyword: String
        let meanText = Const.mean
        let descriptionText = Const.explain
        let relatedText = Const.related
        var currentViewState: ViewState = .loading
        var meanIsvalid: Bool = false
        var desIsvalid: Bool = false
        var videoIsvalid: Bool = false
    }
    
    enum ViewState {
        case loading
        case success
        case failure
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
        case selectedRelatedModel(RelatedVideoEntity) // 관련 영상 선택
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
                    await send(.networkType(.fetchSearch))
                }
                
            case .networkType(.fetchSearch):
                return .run { [state = state] send in
                    print(state.currentSearchKeyword)
                    let result = await searchRepository.fetchSearch(state.currentSearchKeyword)
                    
                    switch result {
                    case let .success(data):
                        await send(.dataTransType(.searchDatas(data)))
                    case let .failure(error):
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case let .dataTransType(.searchDatas(entitys)):
                guard let searchResult = entitys.first else {
                    state.currentViewState = .failure
                    return .none
                }
                
                state.searchResultEntity = searchResult
                state.currentViewState = .success
                
                // 뜻, 설명, 관련 동영상이 있는지 여부를 파악하여
                // 해당 값에 따라서 어떤 뷰를 보여줄지 판단해주는 로직
                // 만약 세개다 없다면 오류뷰를 띄어준다.
                if let mean = searchResult.mean {
                    if mean.isEmpty && searchResult.description.isEmpty {
                        state.meanIsvalid = false
                        state.desIsvalid = false
                    } else {
                        state.meanIsvalid = true
                        state.desIsvalid = true
                    }
                } else {
                    if searchResult.description.isEmpty {
                        state.meanIsvalid = false
                        state.desIsvalid = false
                    } else {
                        state.meanIsvalid = false
                        state.desIsvalid = true
                    }
                }
                
                if searchResult.relatedVideos.isEmpty {
                    state.videoIsvalid = false
                } else {
                    state.videoIsvalid = true
                }
                
            case let .dataTransType(.errorInfo(error)):
                state.currentViewState = .failure
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
