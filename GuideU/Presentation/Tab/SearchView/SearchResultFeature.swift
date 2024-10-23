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
        var searchResultEntity: SearchResultEntity
        let meanText = Const.mean
        let descriptionText = Const.explain
        let relatedText = Const.related
        var currentViewState: ViewState = .loading
        var openURLCase: OpenURLCase? = nil
        var meanIsvalid: Bool = false
        var desIsvalid: Bool = false
        var videoIsvalid: Bool = false
        var dialogPresent: Bool = false
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
        case successOpenURL
        case socialTapped(String)
    }
    
    enum DataTransType {
        case searchDatas(SearchResultEntity)
        case errorInfo(String)
    }
    
    @Dependency(\.urlDividerManager) var urlDividerManager
    
    var body: some ReducerOf<Self> {
        core()
    }
}

extension SearchResultFeature {
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewCycleType(.viewOnAppear):
                return .run { [state = state] send in
                    await send(.dataTransType(.searchDatas(state.searchResultEntity)))
                }
                
            case let .viewEventType(.selectedRelatedModel(model)):
                state.openURLCase = urlDividerManager.dividerURLType(url: model.link)
                
            case .viewEventType(.successOpenURL):
                state.openURLCase = nil
                
            case let .viewEventType(.socialTapped(url)):
                state.openURLCase = urlDividerManager.dividerURLType(url: url)
                
            case let .dataTransType(.searchDatas(entity)):
                state.currentViewState = .success
                
                // 뜻, 설명, 관련 동영상이 있는지 여부를 파악하여
                // 해당 값에 따라서 어떤 뷰를 보여줄지 판단해주는 로직
                // 만약 세개다 없다면 오류뷰를 띄어준다.
                if let mean = entity.mean {
                    state.meanIsvalid = !mean.isEmpty
                } else {
                    state.meanIsvalid = false
                }
                
                state.desIsvalid = !entity.description.isEmpty
                state.videoIsvalid = entity.resultType == .character ? !entity.links.isEmpty : !entity.relatedVideos.isEmpty
                
            case let .dataTransType(.errorInfo(error)):
                state.currentViewState = .failure
                #if DEBUG
                print(errorHandling(error) ?? "nil")
                #endif  
            case .viewEventType(.backButtonTapped):
                return .send(.delegate(.backButtonTapped))
                
            default:
                break
            }
            return .none
        }
    }
}
