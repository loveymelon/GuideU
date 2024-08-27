//
//  ExImage.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/12/24.
//

import SwiftUI

extension Image {
    
    static let appLogo = Image(.appLogo)
    static let defaultBack = Image(.defaultBack)
    static let search = Image(.search)
    static let dropDown = Image(.dropDownButton)
    
    enum TabbarImage {
        enum noneTab {
            static let homeTab = Image(.homeTab)
            static let memeTab = Image(.memeTab)
            static let historyTab = Image(.historyTab)
            static let settingTab = Image(.settingTab)
        }
        
        enum selected {
            static let homeTab = Image(.homeSelectedTab)
            static let memeTab = Image(.memeSeletedTab)
            static let historyTab = Image(.historySelectedTab)
            static let settingTab = Image(.settingSelectedTab)
        }
    }
    
    enum SplashImage {
        static let splash = Image(.splash1)
    }
    
    enum OnBoardImage: CaseIterable {
        case first
        case second
        case third
        case fore
        
        var img: Image {
            switch self {
            case .first:
                return Image(.page1)
            case .second:
                return Image(.page2)
            case .third:
                return Image(.page3)
            case .fore:
                return Image(.page4)
            }
        }
    }
    
    enum chevron {
        case up
        case down
        
        var img: Image {
            switch self {
            case .up:
                return Image(.chevronUp)
            case .down:
                return Image(.chevronDown)
            }
        }
    }
}

