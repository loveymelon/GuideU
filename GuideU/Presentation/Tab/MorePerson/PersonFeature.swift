//
//  PersonFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/20/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PersonFeature: GuideUReducer {
    
    @ObservableState
    struct State: Equatable {
        var headerState = HeaderEntity(title: "동영상이 없어요!", channelName: "동영상이 없어요!", time: "00:00")
        var sharedURL: String = ""
        var charactersInfo: [YoutubeCharacterEntity] = []
        var bookElementsInfo: [BookElementsEntity] = []
        var selectedURL: IdentifiableURLEntity? = nil
        var currentMoreType: MoreType = .characters
        var identifierURL: String
    }
    
    
    enum Action {
        case viewCycleType(ViewCycleType)
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        
        case delegate(Delegate)
        
        //binding
        case bindingURL(IdentifiableURLEntity?)
        
        enum Delegate {
            
        }
    }
    
    enum ViewCycleType {
        case onAppear
    }
    
    enum ViewEventType {
        case switchCurrentType(MoreType)
        case socialTapped(String)
    }
    
    enum DataTransType {
        case characters([YoutubeCharacterEntity])
        case booksElements([BookElementsEntity])
        case youtubeURL(String)
        case errorInfo(String)
    }
    
    enum NetworkType {
        case fetchCharacters(String)
        case fetchMemes(String)
        case search(String)
    }
    
    enum CancelId: Hashable {
        
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
    
    @Dependency(\.characterRepository) var repository
    
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
                print("tap")
                if let url = URL(string: url) {
                    state.selectedURL = IdentifiableURLEntity(url: url)
                }
                
                
            case let .networkType(.fetchCharacters(identifier)):
                return .run { send in
                    let result = await repository.fetchCharacters(id: identifier)
                    
                    switch result {
                    case let .success(data):
                        await send(.dataTransType(.characters(data)))
                    case let .failure(error):
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case let .networkType(.fetchMemes(identifier)):
                return .run { send in
                    let result = await repository.fetchMemes(id: identifier)
                    
                    switch result {
                    case let .success(data):
                        await send(.dataTransType(.booksElements(data)))
                    case let .failure(error):
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case let .dataTransType(.characters(entitys)):
                state.charactersInfo = entitys
                print("characters", state.charactersInfo)
                
            case let .dataTransType(.booksElements(entitys)):
                state.bookElementsInfo = entitys
//                print("memes", state.memesInfo)
                
            case let .dataTransType(.errorInfo(error)):
                print(error)
                
            case let .dataTransType(.youtubeURL(urlString)):
                if let url = URL(string: urlString),
                   let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                   let queryItems = components.queryItems {
                    
                    var string: String? = nil
                    
                    if let vValue = queryItems.first(where: { $0.name == "v" })?.value {
                        string = vValue
                    } else if let vValue = queryItems.first(where: { $0.name == "si" })?.value {
                        string = vValue
                    }
                    if let string {
                        print( string )
                        return .run { send in
                            await send(.networkType(.fetchCharacters(string)))
                            await send(.networkType(.fetchMemes(string)))
                            UserDefaultsManager.sharedURL = nil
                        }
                    } else {
                        print("notFound")
                    }
                    
                    UserDefaultsManager.sharedURL = nil
                    
                    
                } else {
                    print("Invalid URL")
                }
                
            case let .bindingURL(socialURL):
                print("binding")
                state.selectedURL = socialURL
                
            default:
                break
            }
            return .none
        }
    }
}
