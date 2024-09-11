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
        var skipIndex = 0
        
        var limit = 20
        var dialogPresent: Bool = false
        var selectedIndex: Int = 0
        
        var videoInfos: [VideosEntity] = []
        var onAppearIsValid: Bool = true
        var seletedVideo: VideosEntity? = nil
        
        var searchState: SearchFeature.State? = nil
        
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
        
        // searchAction
        case searchAction(SearchFeature.Action)
        
        case delegate(Delegate)
        enum Delegate {
            case detailButtonTapped(String)
        }
        /// Binding
        case currentText(String)
        case currentIndex(Int)
        case selectedVideo(VideosEntity?)
        case dialogBinding(Bool)
    }
    
    enum ViewCycleType {
        case onAppear
    }
    
    enum ViewEventType {
        case onSubmit
        case videoOnAppear(Int)
        case searchViewChanged
        case selectedVideoIndex(Int)
        case youtubeButtonTapped
        case detailButtonTapped
    }
    
    enum DataTransType {
        case videosInfo([VideosEntity], isScroll: Bool)
        case errorInfo(String)
    }
    
    enum NetworkType {
        case fetchVideos(Const.Channel, Int, Int, isScroll: Bool)
        case fetchCharacter(Int)
    }
    
    enum CancelId: Hashable {
        case categoryID
        case scrollID
        case searchID
    }
    
    @Dependency(\.videoRepository) var videoRepository
    @Dependency(\.characterRepository) var characterRepository
    @Dependency(\.realmRepository) var realmRepository
    
    var body: some ReducerOf<Self> {
        core()
            .ifLet(\.searchState, action: \.searchAction) {
                SearchFeature()
            }
    }
}

extension MoreCharacterFeature {
    
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewCycleType(.onAppear):
                if state.onAppearIsValid {
                    state.onAppearIsValid = false
                    return fetchVideos(state: &state, isScroll: false)
                }
                
            case let .viewEventType(.videoOnAppear(index)):
                
                if state.skipIndex < index {
                    state.skipIndex = index
                    if (state.videoInfos.count - 1) - index <= 5 {
                        // .debounce(id: CancelId.scrollID, for: 1, scheduler: RunLoop.main, options: nil)
                        return fetchVideos(state: &state, isScroll: true)
                            .debounce(id: CancelId.scrollID, for: 1, scheduler: RunLoop.main, options: nil)
                            
                    }
                }
                
            case .viewEventType(.searchViewChanged):
                state.searchState = SearchFeature.State()
                
            case let .viewEventType(.selectedVideoIndex(num)):
                state.selectedIndex = num
                return .send(.dialogBinding(true))
                
            case .viewEventType(.youtubeButtonTapped):
                state.seletedVideo = state.videoInfos[state.selectedIndex]
                
                let result = realmRepository.videoHistoryCreate(videoData: state.videoInfos[state.selectedIndex])
                
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    return .send(.dataTransType(.errorInfo(error.description)))
                }
                
            case .viewEventType(.detailButtonTapped):
                return .run { [state = state] send in
                    await send(.delegate(.detailButtonTapped(state.videoInfos[state.selectedIndex].identifier)))
                }
                
            case let .networkType(.fetchVideos(channel, skip, limit, isScroll)):
                return .run { send in
                    let result = await videoRepository.fetchVideos(channel: channel, skip: skip, limit: limit)
                    
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
                state.skipIndex = 0
                return fetchVideos(state: &state, isScroll: false)
                    .debounce(id: CancelId.categoryID, for: 1, scheduler: RunLoop.main, options: nil)
                
            case let .currentText(text):
                state.currentText = text
                
            case .searchAction(.delegate(.closeButtonTapped)):
                state.searchState = nil
                
            case let .selectedVideo(data):
                state.seletedVideo = data
                
            case let .dialogBinding(isValid):
                state.dialogPresent = isValid
                
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
            await send(.networkType(.fetchVideos(state.dropDownOptions[state.currentIndex], state.currentStart, state.limit, isScroll: isScroll)))
        }
    }
}
