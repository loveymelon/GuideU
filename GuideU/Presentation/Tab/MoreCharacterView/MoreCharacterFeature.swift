//
//  MoreCharacterFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MoreCharacterFeature: GuideUReducer {
    
    @ObservableState
    struct State: Equatable {
        var dropDownOptions = Const.Channel.allCases
        var currentText = ""
        var currentIndex = 0
        var currentStart = 0
        var limit = 20
        
        var videoInfos: [VideosEntity] = []
        
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
        case videoOnAppear(Int)
    }
    
    enum DataTransType {
        case videosInfo([VideosEntity], isScroll: Bool)
        case errorInfo(String)
    }
    
    enum NetworkType {
        case fetchVideos([String], Int, Int, isScroll: Bool)
        case fetchCharacter(Int)
    }
    
    enum CancelId: Hashable {
        case categoryID
        case scrollID
        case searchID
    }
    
    @Dependency(\.videoRepository) var videoRepository
    @Dependency(\.characterRepository) var characterRepository
    
    var body: some ReducerOf<Self> {
       core()
    }
}

extension MoreCharacterFeature {
    
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewCycleType(.onAppear):
                return fetchVideos(state: &state, isScroll: false)
                
            case let .viewEventType(.videoOnAppear(index)):
                if (state.videoInfos.count - 1) - index <= 3 {
                    return fetchVideos(state: &state, isScroll: true)
                        .debounce(id: CancelId.scrollID, for: 1, scheduler: RunLoop.main, options: nil)
                }
             
            case let .networkType(.fetchVideos(channelId, skip, limit, isScroll)):
                return .run { send in
                    let result = await videoRepository.fetchVideos(channelId: channelId, skip: skip, limit: limit)
                    
                    switch result {
                    case let .success(data):
                        await send(.dataTransType(.videosInfo(data, isScroll: isScroll)))
                    case let .failure(error):
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case let .networkType(.fetchCharacter(id)):
                return .run { send in
                    let result = await characterRepository.fetchCharacter(id: id)
                    
                    switch result {
                    case let .success(data):
                        print("character", data)
                    case let .failure(error):
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case let .dataTransType(.videosInfo(videos, isScroll)):
                if isScroll {
                    state.videoInfos.append(contentsOf: videos)
                    state.currentStart += (state.limit + 1)
                } else {
                    state.videoInfos = videos
                    state.currentStart += (state.limit + 1)
                }
                
            case let .dataTransType(.errorInfo(error)):
                print(error)
                
                //binding action setting
            case let .currentIndex(index):
                state.currentIndex = index
                state.currentStart = 0
                return fetchVideos(state: &state, isScroll: false)
                    .debounce(id: CancelId.categoryID, for: 1, scheduler: RunLoop.main, options: nil)
                
            case let .currentText(text):
                state.currentText = text
                
            default:
                break
            }
            
            return .none
        }
    }
}

extension MoreCharacterFeature {
    private func fetchVideos(state: inout State, isScroll: Bool) -> Effect<Action> {
        return .run { [state = state] send in
            await send(.networkType(.fetchVideos(state.dropDownOptions[state.currentIndex].channelIDs, state.currentStart, state.limit, isScroll: isScroll)))
        }
    }
}
