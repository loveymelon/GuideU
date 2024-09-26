//
//  GuideUAppDelegate.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/26/24.
//

import SwiftUI
import FirebaseCore


final class GuideUAppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
