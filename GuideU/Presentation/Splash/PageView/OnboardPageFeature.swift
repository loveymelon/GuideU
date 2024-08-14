//
//  OnboardPageFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct OnboardPageFeature {
    
    struct State: Equatable {}
    
    enum Action {
        
        case startButtonTapped
        
        case delegate(Delegate)
        
        enum Delegate {
            case startButtonTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .startButtonTapped:
                return .send(.delegate(.startButtonTapped))
             
            default:
                break
            }
            
            return .none
        }
    }
}
