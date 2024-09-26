//
//  HapticFeedbackManager.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/26/24.
//

import UIKit

struct HapticFeedbackManager {
    @MainActor
    func notificationStyle(type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    @MainActor
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
