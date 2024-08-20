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
    struct State {
        var headerState = HeaderEntity(title: "동영상이 없어요!", channelName: "우왁굳의 게임방송", time: "00:00")
    }
    
    enum Action {
        case onAppear
        
        
        case delegate(Delegate)
        enum Delegate {
            
        }
    }
    
    var body: some ReducerOf<Self> {
        core()
    }
    
}

extension PersonFeature {
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                
                return .none
                
            default:
                break
            }
            return .none
        }
    }
}
