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
        let pageLimit = 10
        
        let dropDownOptions = Const.Channel.allCases
        var currentDropDownOption = Const.Channel.all
        var currentText = ""
        var dropDownIndex = 0
        
        let currentData = CurrentData()
        var dialogPresent: Bool = false
        var selectedIndex: Int = 0
        
        var videoInfos: [VideosEntity] = []
        var onAppearIsValid: Bool = true
        var openURLCase: OpenURLCase? = nil
        var alertMessage: AlertMessage? = nil
        
        var scrollToTop = false
    }
    
    final class CurrentData: @unchecked Sendable, Equatable {
        let id = UUID ()
        var currentStart = 0
        var skipIndex = 0
        var loadingTrigger = true
        var listLoadTrigger = true
        
        static func == (lhs: CurrentData, rhs: CurrentData) -> Bool {
            lhs.id == rhs.id
        }
        
        deinit {
            print("asd")
        }
        func reset() {
            currentStart = 0
            skipIndex = 0
        }
    }
    
    enum Action {
        case viewCycleType(ViewCycleType)
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        case alertAction(AlertAction)
        
        case delegate(Delegate)
        enum Delegate {
            case detailButtonTapped(String)
            case searchBarTapped
        }
        /// Binding
        case currentText(String)
        case dropDownIndex(Int)
        case selectedVideo(VideosEntity?)
        case dialogBinding(Bool)
        case alertBinding(AlertMessage?)
        
        
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
        case resetData
        
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
    
    enum AlertAction {
        case showAlert(AlertMessage)
        case checkAlert(AlertMessage)
        case cancelAlert(AlertMessage)
    }
    
    enum CancelId: Hashable {
        case categoryID
        case scrollID
        case searchID
    }
    
    private let dataSourceActor = DataSourceActor()
    
    @Dependency(\.videoRepository) var videoRepository
    @Dependency(\.urlDividerManager) var urlDividerManager
        
    private let limit = 40
    
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
                state.currentData.listLoadTrigger = false
                return .send(.viewEventType(.sideCheckedIndex(index)))
                
            case let .viewEventType(.sideCheckedIndex(index)):
                if state.currentData.skipIndex < index {
                    state.currentData.skipIndex = index
                    
                    if (state.videoInfos.count - 1) - index <= state.pageLimit {
                        
                        return fetchVideos(state: &state, isScroll: true)
                            .throttle(id: CancelId.scrollID, for: 2, scheduler: DispatchQueue.global(qos: .userInteractive).eraseToAnyScheduler(), latest: false)
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
                
            case .viewEventType(.resetData):
                state.currentData.reset()
                
                return fetchVideos(state: &state, isScroll: false)
                
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
                    state.currentData.listLoadTrigger = true
                    state.currentData.currentStart += state.videoInfos.count + 1
                } else {
                    state.videoInfos = videos
                    state.currentData.loadingTrigger = false
                    state.currentData.listLoadTrigger = true
                    state.currentData.currentStart += state.videoInfos.count + 1
                }
                
            case let .dataTransType(.selectVideoURL(selectURL)):
                guard let youtubeURL = selectURL else { return .none }
                state.openURLCase = urlDividerManager.dividerURLType(url: youtubeURL)
                
            case let .dataTransType(.errorInfo(error)):
                if let errorMSG = errorHandling(error) {
                    #if DEBUG
                        print(errorMSG)
                    #endif
                    return .send(.alertAction(.showAlert(.severError(nil))))
                }
                
                //binding action setting
            case let .dropDownIndex(index):
                state.dropDownIndex = index
                let selected = Const.Channel.allCases[index]
                if state.currentDropDownOption == selected {
                    return .none
                } else {
                    state.currentDropDownOption = selected
                    state.currentData.reset()
                    state.currentData.loadingTrigger = true
                }
                return fetchVideos(state: &state, isScroll: false)
                
            case let .currentText(text):
                state.currentText = text
                
            case let .dialogBinding(isValid):
                state.dialogPresent = isValid
                
            case let .alertBinding(alertMessage):
                state.alertMessage = alertMessage
                
            case .parent(.resetToHome):
                state.scrollToTop.toggle()
                
            case let .alertAction(action):
                switch action {
                case let .showAlert(alert):
                    state.alertMessage = alert
                    
                case .checkAlert:
                    state.alertMessage = nil
                    
                case .cancelAlert:
                    state.alertMessage = nil
                }
                
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
            await send(.networkType(.fetchVideos(state.dropDownOptions[state.dropDownIndex], state.currentData.currentStart, limit, isScroll: isScroll)))
        }
        .debounce(id: CancelId.categoryID, for: 1, scheduler: DispatchQueue.global(qos: .userInitiated), options: nil)
    }
}
