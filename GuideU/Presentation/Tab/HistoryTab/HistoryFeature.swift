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
        case viewOnAppear
        case viewDisAppear
    }
    
    enum ViewEventType {
        case videoTapped(VideosEntity)
    }
    
    enum DataTransType {
        case errorInfo(String)
    }
    
    enum NetworkType {
        
    }
    
    enum CancelId: Hashable {
        
    }
    
    @Dependency(\.realmRepository) var realmRepository
    
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
                let result = realmRepository.videoHistoryCreate(videoData: entity)
                
                if case let .failure(error) = result {
                    return .run { send in
                        await send(.dataTransType(.errorInfo(error.description)))
                    }
                }
                
            case let .dataTransType(.errorInfo(error)):
                state.videosEntity = []
                print(error)
                
            default:
                break
            }
            return .none
        }
    }
}
