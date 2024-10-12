//
//  PersonFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/20/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PersonFeature: GuideUReducer, GuideUReducerOptional {
    
    @ObservableState
    struct State: Equatable {
        var headerState = HeaderEntity.initialSelf
        var videoInfo: VideosEntity = VideosEntity()
        var sharedURL: String = ""
        var charactersInfo: [YoutubeCharacterEntity] = []
        var bookElementsInfo: [BookElementsEntity] = []
        var selectedURL: IdentifiableURLEntity? = nil
        var currentMoreType: MoreType = .characters
        var identifierURL: String
        var openURLCase: OpenURLCase? = nil
        var characterState: ViewState = .loading
        var memeState: ViewState = .loading
        var videoState: ViewState = .loading
    }
    
    enum ViewState {
        case loading
        case content
        case severError
        case none
    }
    
    enum DataType {
        case header
        case character
        case meme
        case other
    }
    
    enum Action {
        case viewCycleType(ViewCycleType)
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        
        case delegate(Delegate)
        case parentAction(ParentAction)
        
        //binding
        case bindingURL(IdentifiableURLEntity?)
        
        enum Delegate {
            case backButtonTapped
        }
        
        enum ParentAction {
            case sharedURL(String)
        }
    }
    
    enum ViewCycleType {
        case onAppear
    }
    
    enum ViewEventType {
        case switchCurrentType(MoreType)
        case socialTapped(String)
        case backButtonTapped
        case moreButtonTapped
        case successOpenURL
    }
    
    enum DataTransType {
        case characters([YoutubeCharacterEntity])
        case booksElements([BookElementsEntity])
        case videodatas((header: HeaderEntity, video: VideosEntity)?)
        case youtubeURL(String)
        case checkURL(String)
        case errorInfo(String, DataType)
    }
    
    enum NetworkType {
        case fetchCharacters(String)
        case fetchMemes(String)
        case search(String)
        case fetchVideo(String)
    }
    
    enum CancelId: Hashable {
        case sharedURL
    }
    
    enum MoreType: CaseIterable {
        case characters
        case memes
        
        var text: String {
            switch self {
            case .characters:
                return "등장인물"
            case .memes:
                return "사용되는 밈"
            }
        }
    }
    
    private let realmRepository = RealmRepository()
    
    @Dependency(\.characterRepository) var repository
    @Dependency(\.videoRepository) var videoRepository
    @Dependency(\.urlDividerManager) var urlDividerManager
    
    var body: some ReducerOf<Self> {
        core()
    }
    
}

extension PersonFeature {
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewCycleType(.onAppear):
                if !state.identifierURL.isEmpty {
                    return .run { [state = state] send in
                        await send(.dataTransType(.youtubeURL(state.identifierURL)))
                    }
                }
                
            case let .viewEventType(.switchCurrentType(moreType)):
                state.currentMoreType = moreType
                
            case let .viewEventType(.socialTapped(url)):
                state.openURLCase = urlDividerManager.dividerURLType(url: url)
                
            case .viewEventType(.moreButtonTapped):
                let identifierURL = state.identifierURL
                return .run { send in
                    await send(.dataTransType(.checkURL(identifierURL)))
                }
                
            case .viewEventType(.successOpenURL):
                state.openURLCase = nil
                
            case let .networkType(.fetchCharacters(identifier)):
                return .run { send in
                    let result = await repository.fetchCharacters(id: identifier)
                    
                    switch result {
                    case let .success(data):
                        await send(.dataTransType(.characters(data)))
                    case let .failure(error):
                        await send(.dataTransType(.errorInfo(error, .character)))
                    }
                }
                
            case let .networkType(.fetchMemes(identifier)):
                return .run { send in
                    let result = await repository.fetchMemes(id: identifier)
                    
                    switch result {
                    case let .success(data):
                        await send(.dataTransType(.booksElements(data)))
                    case let .failure(error):
                        await send(.dataTransType(.errorInfo(error, .meme)))
                    }
                }
                
            case let .networkType(.fetchVideo(identifier)):
                return .run { send in
                    let result = await videoRepository.fetchVideoHeader(identifier: identifier)
                    
                    switch result {
                    case let .success(data):
                        await send(.dataTransType(.videodatas((data))))
                    case let .failure(error):
                        await send(.dataTransType(.errorInfo(error, .header)))
                    }
                }
                
            case let .dataTransType(.characters(entitys)):
                state.charactersInfo = entitys
                state.characterState = state.charactersInfo.isEmpty ? .none : .content
                
            case let .dataTransType(.booksElements(entitys)):
                state.bookElementsInfo = entitys
                state.memeState = state.bookElementsInfo.isEmpty ? .none : .content
                
            case let .dataTransType(.videodatas(entity)):
                guard let headerData = entity?.header,
                      let videoData = entity?.video else {
                    state.videoState = .none
                    return .none
                }
                
                state.headerState = headerData
                state.videoInfo = videoData
                
                state.videoState = .content
                return .run {[ state = state ] send in
                    let result = await realmRepository.videoHistoryCreate(videoData: state.videoInfo)
                    
                    if case let .failure(error) = result {
                        await send(.dataTransType(.errorInfo(error.description, .other)))
                    }
                }

            case let .dataTransType(.checkURL(identifierURL)):
                if identifierURL.contains(Const.youtubeBaseURL) {
                    state.openURLCase = urlDividerManager.dividerURLType(url: identifierURL)
                }
                
            case let .dataTransType(.errorInfo(error, dataType)):
                switch dataType {
                case .header:
                    state.videoState = .severError
                case .character:
                    state.characterState = .severError
                case .meme:
                    state.memeState = .severError
                case .other:
                    print(error)
                }
                
            case let .dataTransType(.youtubeURL(urlString)):
                if let identifier = urlDividerManager.dividerResult(type: .youtubeIdentifier(urlString)) {
                    return .run { send in
                        await send(.networkType(.fetchVideo(identifier)))
                        await send(.networkType(.fetchCharacters(identifier)))
                        await send(.networkType(.fetchMemes(identifier)))
                        UserDefaultsManager.sharedURL = nil
                    }
                    .debounce(id: CancelId.sharedURL, for: 1, scheduler: RunLoop.main)
                } else {
                    UserDefaultsManager.sharedURL = nil
                    state.videoState = .none
                }
                
            case let .parentAction(.sharedURL(identifierURL)):
                state.videoState = .loading
                state.identifierURL = identifierURL
                
                return .run { [state = state] send in
                    await send(.dataTransType(.youtubeURL(state.identifierURL)))
                }
                
            case let .bindingURL(socialURL):
                print("binding", socialURL)
                state.selectedURL = socialURL
                
                /// 뒤로가기 이벤트
            case .viewEventType(.backButtonTapped):
                return .send(.delegate(.backButtonTapped))
                
            default:
                break
            }
            return .none
        }
    }
}
