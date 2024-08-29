//
//  MoreCharacterFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MoreCharacterFeature {
    
    @ObservableState
    struct State: Equatable {
        var dropDownOptions = Const.Channel.allCases
        var currentText = ""
        var currentIndex = 0
        var targetIndex = 100
        
        let constViewState = ConstViewState()
    }
    
    struct ConstViewState: Equatable {
        let placeHolder =  "알고싶은 왁타버스 영상을 여기에"
        let main = "나는 왁타버스에서"
        let sub = "을 더 알아보고 싶어요."
        let targetString = "왁타버스"
    }
    
    enum Action {
        case viewCycleType(ViewCycleType)
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        
        case delegate(Delegate)
        enum Delegate {
            
        }
        /// Binding
        case currentText(String)
        case currentIndex(Int)
        
    }
    
    enum ViewCycleType {
        case onAppear
    }
    
    enum ViewEventType {
        case onSubmit
    }
    
    enum DataTransType {
        case videosInfo([VideosEntity])
        case errorInfo(String)
    }
    
    enum NetworkType {
        case fetchVideos([String], Int, Int)
    }
    
    @Dependency(\.videoRepository) var repository
    
    var body: some ReducerOf<Self> {
       core()
    }
}

extension MoreCharacterFeature {
    
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewCycleType(.onAppear):
                
                return fetchVideos(state: &state)
             
            case let .networkType(.fetchVideos(channelId, skip, limit)):
                return .run { send in
                    let result = await repository.fetchVideos(channelId: channelId, skip: skip, limit: limit)
                    
                    switch result {
                    case let .success(data):
                        await send(.dataTransType(.videosInfo(data)))
                    case let .failure(error):
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case let .dataTransType(.videosInfo(videos)):
                print(videos)
                
            case let .dataTransType(.errorInfo(error)):
                print(error)
                
            default:
                break
            }
            
            return .none
        }
    }
}

extension MoreCharacterFeature {
    private func fetchVideos(state: inout State) -> Effect<Action> {
        return .run { [state = state] send in
            await send(.networkType(.fetchVideos(state.dropDownOptions[state.currentIndex].channelIDs, state.currentIndex, 100)))
        }
    }
}
