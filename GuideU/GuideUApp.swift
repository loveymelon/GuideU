//
//  GuideUApp.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/12/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct GuideUApp: App {
    
    @UIApplicationDelegateAdaptor(GuideUAppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootCoordinatorView(store: Store(initialState: RootCoordinator.State.initialState, reducer: {
                RootCoordinator()
            }))
        }
    }
}
