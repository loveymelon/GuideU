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
    
    struct AlertMessage: Identifiable, Equatable {
        let id = UUID()
        var title = ""
        var actionTitle = ""
        var cancelTitle = ""
        var message: String = ""
    }
    
    enum Action {
        case router(IdentifiedRouterActionOf<RootScreen>)
        
        case tabNavCoordinatorAction(TabNavCoordinator.Action)
        case viewCycle(ViewCycle)
        case checkError(Bool)
        case networkError(String)
        case networkErrorType(NetworkErrorType)
        case networkMonitorStart
        
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
                    await nwPathMonitorManager.start()
                    await send(.networkErrorType(.nwMonitor))
                }
            
//            case .networkErrorType(.nwMonitor):
//                return Effect.publisher {
//                    return nwPathMonitorManager.currentConnectionTrigger
//                        .receive(on: RunLoop.main)
//                        .removeDuplicates()
//                }
//                .map { isValid -> Action in
//                    return .checkError(isValid)
//                }
//                .debounce(id: CancelID.nwMonitor, for: 1, scheduler: RunLoop.main)
                
            case .networkErrorType(.nwMonitor):
                return .run { send in
                    
                    let continuation = await nwPathMonitorManager.getToConnectionTrigger()
                    
                    for await isValid in continuation {
                        await send(.checkError(isValid))
                    }
                }
                
            case .networkErrorType(.timeOut):
                return Effect.publisher {
                    return networkManager.networkError
                        .receive(on: RunLoop.main)
                }
                .map { isValid -> Action in
                    return .networkError("네트워크 시간 초과입니다 잠시후에 다시 시작해주세요")
                }
                .debounce(id: CancelID.networkManager, for: 1, scheduler: RunLoop.main)
                
            case let .checkError(isValid):
                if state.currentNetworkState != isValid {
                    state.currentNetworkState = isValid
                    if !isValid {
                        return .run { send in
                            await send(.networkError("네트워크 연결 상태가 좋지 않습니다. 네트워크 상태를 체크해주세요."))
                        }
                    } else {
                        state.alertMessage = nil
                    }
                }
        
            case let .networkError(networkMessage):
                state.alertMessage = AlertMessage(message: networkMessage)
                print(state.alertMessage?.message)
                
            case let .router(.routeAction(id: _, action: .splash(.delegate(.isFirstUser(trigger))))):

                if trigger {
                    state.routes.push(.onboardPage(OnboardPageFeature.State()))
                } else {
                    state.viewState = .tab
                }
                
            case let .bindingMessage(alert):
                state.alertMessage = alert
                
            default:
                break
            }
            
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
