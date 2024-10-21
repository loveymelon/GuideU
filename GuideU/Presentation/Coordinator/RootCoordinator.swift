//
//  RootCoordinator.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import Foundation
import ComposableArchitecture
@preconcurrency import TCACoordinators

@Reducer(state: .equatable)
enum RootScreen {
    case splash(SplashFeature)
    case onboardPage(OnboardPageFeature)
}

@Reducer
struct RootCoordinator: Reducer {
    
    @ObservableState
    struct State: Equatable, Sendable {
        static let initialState = State(routes: [.root(.splash(SplashFeature.State()), embedInNavigationView: true)])
        
        var routes: IdentifiedArrayOf<Route<RootScreen.State>>
        var onAppearTrigger: Bool = true
        var viewState: RootCoordinatorViewState = .start
        var tabNavCoordinator: TabNavCoordinator.State = TabNavCoordinator.State.initialState
        
        var currentNetworkState = true
        var alertMessage: AlertMessage? = nil
    }

    enum Action {
        case router(IdentifiedRouterActionOf<RootScreen>)
        
        case tabNavCoordinatorAction(TabNavCoordinator.Action)
        case viewCycle(ViewCycle)
        case networkErrorType(NetworkErrorType)
        case networkMonitorStart
        
        case alertAction(AlertAction)
        
        // binding
        case bindingMessage(AlertMessage?)
    }
    
    enum NetworkErrorType {
        case nwMonitor
        case timeOut
    }
    
    enum ViewCycle {
        case onAppear
    }

    enum RootCoordinatorViewState: Equatable {
        case start
        case tab
    }
    
    enum CancelID {
        case nwMonitor
        case networkManager
    }
    
    enum AlertAction {
        case showAlert(AlertMessage)
        case checkAlert(AlertMessage)
        case cancelAlert(AlertMessage)
    }
    
    @Dependency(\.nwPathMonitorManager) var nwPathMonitorManager
    @Dependency(\.networkManager) var networkManager
    
    var body: some ReducerOf<Self> {
        Scope(state: \.tabNavCoordinator, action: \.tabNavCoordinatorAction) {
            TabNavCoordinator()
        }
        
        Reduce { state, action in
            switch action {
                
            case .viewCycle(.onAppear):
                if state.onAppearTrigger {
                    state.onAppearTrigger = false
                    return .run { send in
//                        await send(.networkErrorType(.nwMonitor))
                        await send(.networkMonitorStart)
                        await send(.networkErrorType(.timeOut))
                    }
                }
                
            case .networkMonitorStart:
                return .run { send in
                    nwPathMonitorManager.start()
                    await send(.networkErrorType(.nwMonitor))
                }
                
            case .networkErrorType(.nwMonitor):
                return .run { [state = state] send in
                    
                    for await isValid in  nwPathMonitorManager.getToConnectionTrigger() {
                        if state.currentNetworkState != isValid {
                            if !isValid {
                                await send(.alertAction(.showAlert(.networkPathError(nil))))
                            }
                        }
                    }
                }
                
            case .networkErrorType(.timeOut):
                return .run { send in
                    for await text in networkManager.getNetworkError() {
                        await send(.alertAction(.showAlert(.networkError(text))))
                    }
                }
                .debounce(id: CancelID.networkManager, for: 1, scheduler: RunLoop.main)
                
            case let .router(.routeAction(id: _, action: .splash(.delegate(.isFirstUser(trigger))))):

                if trigger {
                    state.routes.push(.onboardPage(OnboardPageFeature.State()))
                } else {
                    state.viewState = .tab
                }
                
            case let .bindingMessage(alert):
                state.alertMessage = alert
            
            case let .alertAction(action):
                switch action {
                case let .showAlert(alert):
                    state.currentNetworkState = true
                    state.alertMessage = alert
                case .checkAlert:
//                    switch alert {
//                    case .networkPathError(_):
//
//                    case .networkError(_):
//
//                    }
                    state.currentNetworkState = false
                    state.alertMessage = nil
                case .cancelAlert:
                    state.currentNetworkState = false
                    state.alertMessage = nil
                }
            
            default:
                break
            }
            
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
