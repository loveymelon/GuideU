//
//  MoreCharacterFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MoreCharacterFeature: GuideUReducer, GuideUReducerOptional, Sendable {
    
    @ObservableState
    struct State: Equatable {
        var dropDownOptions = Const.Channel.allCases
        var currentDropDownOption = Const.Channel.all
        var currentText = ""
        var currentIndex = 0
        var currentStart = 0
        var skipIndex = 0
        
        var limit = 30
        var dialogPresent: Bool = false
        var selectedIndex: Int = 0
        
        var videoInfos: [VideosEntity] = []
        var onAppearIsValid: Bool = true
        var openURLCase: OpenURLCase? = nil
        var alertState: AlertState? = nil
        
        var loadingTrigger = true
        var listLoadTrigger = true
        
        let constViewState = ConstViewState()
        let scrollViewTopID = UUID()
        var scrollToTop = false
    }
    
    struct AlertState: Equatable {
        var title: String = "서버 에러"
        var message: String = "왁타버스 서버에서 문제가 생겼습니다.\n잠시후에 다시 시도해주세요."
        var alertActionTitle: String = "확인"
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
            case detailButtonTapped(String)
            case searchBarTapped
        }
        /// Binding
        case currentText(String)
        case currentIndex(Int)
        case selectedVideo(VideosEntity?)
        case dialogBinding(Bool)
        case alertBinding(AlertState?)
        
        
        case parent(ParentAction)
        
        enum ParentAction {
            case resetToHome
        }
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
        case successOpenURL
        
        // Side Effect
        case sideCheckedIndex(Int)
    }
    
    enum DataTransType {
        case videosInfo([VideosEntity], isScroll: Bool)
        case selectVideoURL(String?)
        case errorInfo(Error)
    }
    
    enum NetworkType {
        case fetchVideos(Const.Channel, Int, Int, isScroll: Bool)
    }
    
    enum CancelId: Hashable {
        case categoryID
        case scrollID
        case searchID
    }
    
    private let dataSourceActor = DataSourceActor()
    
    @Dependency(\.videoRepository) var videoRepository
    @Dependency(\.characterRepository) var characterRepository
    @Dependency(\.urlDividerManager) var urlDividerManager
    
    var body: some ReducerOf<Self> {
        core()
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
                state.listLoadTrigger = false
                return .send(.viewEventType(.sideCheckedIndex(index)))
                
            case let .viewEventType(.sideCheckedIndex(index)):
                
                if state.skipIndex < index {
                    state.skipIndex = index
                    if (state.videoInfos.count - 1) - index <= 8 {
                        return fetchVideos(state: &state, isScroll: true)
                            .throttle(id: CancelId.scrollID, for: 2, scheduler: RunLoop.current.eraseToAnyScheduler(), latest: false)
                    }
                }
                
            case .viewEventType(.searchViewChanged):
                return .send(.delegate(.searchBarTapped))
                
            case let .viewEventType(.selectedVideoIndex(num)):
                state.selectedIndex = num
                return .send(.dialogBinding(true))
                
            case .viewEventType(.youtubeButtonTapped):
                let videoURL = state.videoInfos[state.selectedIndex].videoURL?.absoluteString
                
                return .run { [state = state] send in
                    do {
                        try await dataSourceActor.videoHistoryCreate(videoData: state.videoInfos[state.selectedIndex])
                        
                        await send(.dataTransType(.selectVideoURL(videoURL)))
                        
                    } catch {
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case .viewEventType(.detailButtonTapped):
                return .run { [state = state] send in
                    await send(.delegate(.detailButtonTapped(state.videoInfos[state.selectedIndex].identifier)))
                }
                
            case .viewEventType(.successOpenURL):
                state.openURLCase = nil
                
            case let .networkType(.fetchVideos(channel, skip, limit, isScroll)):
                return .run { send in
                    do {
                        let data = try await videoRepository.fetchVideos(channel: channel, skip: skip, limit: limit)
                        
                        await send(.dataTransType(.videosInfo(data, isScroll: isScroll)))
                    } catch {
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case let .dataTransType(.videosInfo(videos, isScroll)):
                if isScroll {
                    state.videoInfos.append(contentsOf: videos)
                    state.listLoadTrigger = true
                    state.currentStart += (state.limit + 1)
                } else {
                    state.videoInfos = videos
                    state.loadingTrigger = false
                    state.listLoadTrigger = true
                    state.currentStart += (state.limit + 1)
                }
                
            case let .dataTransType(.selectVideoURL(selectURL)):
                guard let youtubeURL = selectURL else { return .none }
                state.openURLCase = urlDividerManager.dividerURLType(url: youtubeURL)
                
            case let .dataTransType(.errorInfo(error)):
                if let errorMSG = errorHandling(error) {
                    print(errorMSG)
                    state.alertState = AlertState()
                }
                
                //binding action setting
            case let .currentIndex(index):
                state.currentIndex = index
                let selected = Const.Channel.allCases[index]
                if state.currentDropDownOption == selected {
                    return .none
                } else {
                    state.currentDropDownOption = selected
                    state.currentStart = 0
                    state.skipIndex = 0
                    state.loadingTrigger = true
                }
                return fetchVideos(state: &state, isScroll: false)
                    .debounce(id: CancelId.categoryID, for: 1, scheduler: RunLoop.main, options: nil)
                
            case let .currentText(text):
                state.currentText = text
                
            case let .dialogBinding(isValid):
                state.dialogPresent = isValid
                
            case let .alertBinding(item):
                state.alertState = item
                
            case .parent(.resetToHome):
                state.scrollToTop.toggle()
                
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
