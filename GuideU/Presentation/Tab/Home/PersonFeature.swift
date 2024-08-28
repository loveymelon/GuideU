//
//  PersonFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/20/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PersonFeature {
    
    @ObservableState
    struct State: Equatable {
        var headerState = HeaderEntity(title: "동영상이 없어요!", channelName: "우왁굳의 게임방송", time: "00:00")
        var characterInfoList: [CharacterEntity] = []
    }
    
    enum Action {
        case viewCycleType(ViewCycleType)
        case viewEventType(ViewEventType)
        case dataTransType(DataTransType)
        case networkType(NetworkType)
        
        case delegate(Delegate)
        enum Delegate {
            
        }
    }
    
    enum ViewCycleType {
        case onAppear
    }
    
    enum ViewEventType {
        
    }
    
    enum DataTransType {
        case characterInfo([CharacterEntity])
        case errorInfo(String)
    }
    
    enum NetworkType {
        case fetchCharacters
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
                return .run { send in
                    print("onAppear")
                    await send(.networkType(.fetchCharacters))
                    print("onAppear2")
                }
                
            case .networkType(.fetchCharacters):
                return .run { send in
                    let result = await repository.fetchCharacter()
                    
                    switch result {
                    case .success(let data):
                        await send(.dataTransType(.characterInfo(data)))
                    case .failure(let error):
                        await send(.dataTransType(.errorInfo(error)))
                    }
                }
                
            case let .dataTransType(.characterInfo(characterList)):
                state.characterInfoList = characterList
                print(state.characterInfoList)
                
            case let .dataTransType(.errorInfo(error)):
                print(error)
                
            default:
                break
            }
            return .none
        }
    }
}
