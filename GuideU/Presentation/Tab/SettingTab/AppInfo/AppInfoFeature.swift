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
        let openSourceLicenseTitle = "오픈소스 라이선스"
        let appOpenSourceLicense = Const.openSourceLicense.allCases
        
        var openURLTrigger: URL? = nil
    }
    
    enum Action {
        case didTapBackButton
        case delegate(Delegate)
        case selectedLicense(Const.openSourceLicense)
        enum Delegate {
            case tapBackButton
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTapBackButton:
                return .send(.delegate(.tapBackButton))
                
            case let .selectedLicense(item):
                guard let url = URL(string: item.urlString) else {
                    return .none
                }
                state.openURLTrigger = url
            default:
                break
            }
            
            return .none
        }
    }
}
