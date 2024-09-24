//
//  AppColorSettingFeature.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/24/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppColorSettingFeature {
    
    @ObservableState
    struct State: Equatable {
        var currentCase: CurrentColorModeCase = .system
    }
    
    enum Action {
        case viewCycle(ViewCycleType)
        case viewEvent(ViewEventType)
    }
    
    enum ViewCycleType {
        case onAppear
    }

    enum ViewEventType {
        case selectedCase(CurrentColorModeCase)
    }
    
    var body: some ReducerOf<Self> {
        core()
    }
}

extension AppColorSettingFeature {
    private func core() -> some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewCycle(.onAppear):
                guard let colorCase = CurrentColorModeCase(rawValue: UserDefaultsManager.colorCase) else {
                    return .none
                }
                state.currentCase = colorCase
                
                
            case let .viewEvent(.selectedCase(caseOf)):
                switch caseOf {
                case .system:
                    break
                case .light:
                    break
                case .dark:
                    break
                }
                
            default:
                break
            }
            return .none
        }
    }
}
