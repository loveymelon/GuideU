//
//  AppInfoFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/20/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppInfoFeature {
    @ObservableState
    struct State: Equatable {
        let navigationTitle = Const.navigationTitle
        let sectionTitle = Const.sectionTitle
        let appVersion = "v"+Const.appShortVersion
        let appLogoImage = "AppLogo"
        let appName = Const.appName
    }
    
    enum Action {
        case didTapBackButton
        case delegate(Delegate)
        
        enum Delegate {
            case tapBackButton
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTapBackButton:
                return .send(.delegate(.tapBackButton))
                
            default:
                break
            }
            
            return .none
        }
    }
}
