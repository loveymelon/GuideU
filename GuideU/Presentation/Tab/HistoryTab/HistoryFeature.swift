//
//  HistoryFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HistoryFeature {
    
    private let realmRepository = RealmRepository()
    
    @ObservableState
    struct State: Equatable {
        var videosEntity: [HistoryVideosEntity] = []
//        var selectedVideoData: VideosEntity = VideosEntity() // 이지랄이 원인인것 같은데
        var selectedVideoData: VideosEntity? = nil
        var dialogPresent: Bool = false
        var openURLCase: OpenURLCase? = nil
    }
    
    enum Action {
        case viewCycleType(ViewCycleType)
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        case delegate(Delegate)
        
        // bindingAction
        case dialogBinding(Bool)
        
        enum Delegate {
            case detailButtonTapped(String)
        }
    }
    
    enum ViewCycleType {
        case viewOnAppear
        case viewDisAppear
    }
    
    enum ViewEventType {
        case videoTapped(VideosEntity)
        case youtubeButtonTapped
        case detailButtonTapped
        case successOpenURL
    }
    
    enum DataTransType {
        case selectVideoURL(String?)
        case cleanSelectData
        case errorInfo(String)
        case successRealmData([HistoryVideosEntity])
    }
    
    enum NetworkType {
        
    }
    
    enum CancelId: Hashable {
        case test
    }
    
    
    
    @Dependency(\.urlDividerManager) var urlDividerManager
    
    var body: some ReducerOf<Self> {
        core()
    }
}

extension HistoryFeature {
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewCycleType(.viewOnAppear):
                state.videosEntity = []
                return .run { send in
                    let result = await realmRepository.fetchVideoHistory()
                    await send(.dataTransType(.successRealmData(result)))
                }
                .throttle(id: CancelId.test, for: 2, scheduler: RunLoop.main.eraseToAnyScheduler(), latest: false)
                   
            case let .viewEventType(.videoTapped(entity)):
                state.selectedVideoData = entity
                return .send(.dialogBinding(true))

            case .viewEventType(.youtubeButtonTapped):
                
                guard let selectedVideoData = state.selectedVideoData else {
                    return .none
                }
                
                let videoURL = selectedVideoData.videoURL?.absoluteString
                
                return .run { send in
                    let result = await realmRepository.videoHistoryCreate(videoData: selectedVideoData)
                    
                    switch result {
                    case .success(_):
                        await send(.dataTransType(.cleanSelectData))
                        await send(.dataTransType(.selectVideoURL(videoURL)))
                        
                    case .failure(let error):
                        await send(.dataTransType(.cleanSelectData))
                        await send(.dataTransType(.errorInfo(error.description)))
                    }
                }
                
            case .viewEventType(.successOpenURL):
                state.openURLCase = nil
                
            case .viewEventType(.detailButtonTapped):
                guard let selectedVideoData = state.selectedVideoData else {
                    return .none
                }
                
                return .run { send in
                    let result = await realmRepository.videoHistoryCreate(videoData: selectedVideoData)
                    
                    if case let .failure(error) = result {
                        await send(.dataTransType(.cleanSelectData))
                        await send(.dataTransType(.errorInfo(error.description)))
                    }
                    await send(.dataTransType(.cleanSelectData))
                    await send(.delegate(.detailButtonTapped(selectedVideoData.identifier)))
                }
                
            case let .dataTransType(.selectVideoURL(selectURL)):
                guard let youtubeURL = selectURL else { return .none }
                state.openURLCase = urlDividerManager.dividerURLType(url: youtubeURL)
                
            case .dataTransType(.cleanSelectData):
                state.selectedVideoData = nil
                
            case let .dataTransType(.errorInfo(error)):
                state.videosEntity = []
                print(error)
                
            case let .dataTransType(.successRealmData(datas)):
                state.videosEntity = datas
                
            case let .dialogBinding(isValid):
                state.dialogPresent = isValid
                
            default:
                break
            }
            return .none
        }
    }
}
