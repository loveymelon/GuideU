//
//  HistoryFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HistoryFeature: GuideUReducer, GuideUReducerOptional {
    
    private let dataSourceActor = DataSourceActor()
    
    @ObservableState
    struct State: Equatable {
        var videosEntity: [HistoryVideosEntity] = []
        var selectedVideoData: VideosEntity? = nil
        var dialogPresent: Bool = false
        var openURLCase: OpenURLCase? = nil
        var viewState: ViewState = .loading
        
        var scrollToTopTrigger = false
        let scrollID = UUID()
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
        case realmType(RealmType)
        case delegate(Delegate)
        case parent(ParentAction)
        
        // bindingAction
        case dialogBinding(Bool)
        
        enum Delegate {
            case detailButtonTapped(String)
        }
        
        enum ParentAction {
            case resetToHistory
            case fetchData
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
        case errorInfo(Error)
        case successRealmData([HistoryVideosEntity])
    }
    
    enum RealmType {
        case fetchData
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
                return .run { send in
                    await send(.realmType(.fetchData))
                }
                   
            case let .viewEventType(.videoTapped(entity)):
                state.selectedVideoData = entity
                return .send(.dialogBinding(true))

            case .viewEventType(.youtubeButtonTapped):
                
                guard let selectedVideoData = state.selectedVideoData else {
                    return .none
                }
                
                let videoURL = selectedVideoData.videoURL?.absoluteString
                
                return .run { send in
                    do {
                        try await dataSourceActor.videoHistoryCreate(videoData: selectedVideoData)
                        
                        await send(.dataTransType(.cleanSelectData))
                        await send(.dataTransType(.selectVideoURL(videoURL)))
                    } catch {
                        await send(.dataTransType(.cleanSelectData))
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case .viewEventType(.successOpenURL):
                state.openURLCase = nil
                
            case .viewEventType(.detailButtonTapped):
                guard let selectedVideoData = state.selectedVideoData else {
                    return .none
                }
                
                return .run { send in
                    do {
                        try await dataSourceActor.videoHistoryCreate(videoData: selectedVideoData)
                        
                        await send(.dataTransType(.cleanSelectData))
                        await send(.delegate(.detailButtonTapped(selectedVideoData.identifier)))
                    } catch {
                        await send(.dataTransType(.cleanSelectData))
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case .realmType(.fetchData):
                return .run { send in
                    let result = await dataSourceActor.fetchVideoHistory()
                    await send(.dataTransType(.successRealmData(result)))
                }
                .throttle(id: CancelId.test, for: 2, scheduler: RunLoop.main.eraseToAnyScheduler(), latest: false)
                
            case let .dataTransType(.selectVideoURL(selectURL)):
                guard let youtubeURL = selectURL else { return .none }
                state.openURLCase = urlDividerManager.dividerURLType(url: youtubeURL)
                
            case .dataTransType(.cleanSelectData):
                state.selectedVideoData = nil
                
            case let .dataTransType(.errorInfo(error)):
                print(errorHandling(error ?? "nil"))
                state.videosEntity = []
                
            case let .dataTransType(.successRealmData(datas)):
                state.viewState = datas.isEmpty ? .failure : .success
                state.videosEntity = datas
                
            case let .dialogBinding(isValid):
                state.dialogPresent = isValid
                
            case .parent(.resetToHistory):
                scrollUP(&state)
                
            case .parent(.fetchData):
                return .run { send in
                    await send(.realmType(.fetchData))
                }
                
            default:
                break
            }
            return .none
        }
    }
    
    private func scrollUP(_ state: inout State) {
        state.scrollToTopTrigger.toggle()
    }
}
