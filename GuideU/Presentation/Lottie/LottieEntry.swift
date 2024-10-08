//
//  LottieEntry.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/8/24.
//

import SwiftUI
import Lottie

struct LottieEntry: View {
    
    let speed: CGFloat
    let setAnimation: AnimationType
    let setLoopMode: loopMode
    
    init(setAnimation: AnimationType, setLoopMode: loopMode = .autoReverse, speed: CGFloat = 1.0) {
        self.setAnimation = setAnimation
        self.setLoopMode = setLoopMode
        self.speed = speed
    }
    
    enum AnimationType {
        case loading
        
        var fileName: String {
            switch self {
            case .loading: return "Loading"
            }
        }
    }
    
    enum loopMode {
        case loop
        case autoReverse
        case once
        case repeatSec(Float)
    }
    
    var body: some View {
        LottieView(animation: .named(setAnimation.fileName))
            .configure { view in
                view.animationSpeed = speed
                switch setLoopMode {
                case .loop:
                    view.loopMode = .loop
                case .autoReverse:
                    view.loopMode = .autoReverse
                case .once:
                    view.loopMode = .playOnce
                case let .repeatSec(count):
                    view.loopMode = .repeat(count)
                }
            }
            .playing()
    }
    
}
