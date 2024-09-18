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
    
    @ObservableState
    struct State: Equatable {
        var videosEntity: [HistoryVideosEntity] = []
        var selectedVideoData: VideosEntity = VideosEntity()
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
    }
    
    enum NetworkType {
        
    }
    
    enum CancelId: Hashable {
        
    }
    
    @Dependency(\.realmRepository) var realmRepository
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
                state.videosEntity = realmRepository.fetchVideoHistory()
                print("실행함 \(state.videosEntity)")
                
            case let .viewEventType(.videoTapped(entity)):
                state.selectedVideoData = entity
                return .send(.dialogBinding(true))

            case .viewEventType(.youtubeButtonTapped):
                let videoURL = state.selectedVideoData.videoURL?.absoluteString
                
                let result = realmRepository.videoHistoryCreate(videoData: state.selectedVideoData)
                
                return .run { send in
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
                let videoInfo = state.selectedVideoData
                
                let result = realmRepository.videoHistoryCreate(videoData: videoInfo)
                
                return .run { send in
                    if case let .failure(error) = result {
                        await send(.dataTransType(.cleanSelectData))
                        await send(.dataTransType(.errorInfo(error.description)))
                    }
                    await send(.dataTransType(.cleanSelectData))
                    await send(.delegate(.detailButtonTapped(videoInfo.identifier)))
                }
                
            case let .dataTransType(.selectVideoURL(selectURL)):
                guard let youtubeURL = selectURL, let identifier = urlDividerManager.dividerResult(type: .youtubeIdentifier(youtubeURL)) else { return .none }
                state.openURLCase = OpenURLCase.youtube(identifier: identifier)
                
            case .dataTransType(.cleanSelectData):
                state.selectedVideoData = VideosEntity()
                
            case let .dataTransType(.errorInfo(error)):
                state.videosEntity = []
                print(error)
                
            case let .dialogBinding(isValid):
                state.dialogPresent = isValid
                
            default:
                break
            }
            return .none
        }
    }
}
