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
    static let close = Image(.closeRounded)
    static let history = Image(.historyTab)
    static let clock = Image(.clock)
    static let backBlack = Image(.backBlack)
    
    enum TabbarImage {
        enum noneTab {
            static let homeTab = Image(.homeTab)
            static let searchTab = Image(.searchTabDis)
            static let historyTab = history
            static let settingTab = Image(.settingTab)
        }
        
        enum selected {
            static let homeTab = Image(.homeTabSelected)
            static let searchTab = Image(.searchTab)
            static let historyTab = Image(.historyTabSelected)
            static let settingTab = Image(.settingTabSelected)
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
    
    enum SocialImages: String {
        case youtube = "youtube"
        case instagram = "instagram"
        case twitterX = "twitter"
        case soop = "afreeca"
        
        var img: Image {
            switch self {
            case .youtube:
                return Image(.youtubeIcon)
            case .instagram:
                return Image(.instagramIcon)
            case .twitterX:
                return Image(.xIcon)
            case .soop:
                return Image(.soopIcon)
            }
        }
    }
    
    enum ErrorImages: String {
        case notWak = "NotWak"
        case noData = "NoData"
        case noVideo = "NoVideo"
    }
}

