//
//  ImageType.swift
//  GuideU
//
//  Created by 김진수 on 10/11/24.
//

import Foundation

enum ImageType {
    enum TabImage {
        enum SelectImage {
            static let home = "HomeTabSelected"
            static let search = "SearchTab"
            static let history = "HistoryTabSelected"
            static let setting = "SettingTabSelected"
            static let meme = "MemeSeletedTab"
        }
        
        enum NormalImage {
            static let home = "HomeTab"
            static let search = "SearchTabDis"
            static let history = "HistoryTab"
            static let setting = "SettingTab"
            static let meme = "MemeTab"
        }
    }
    
    enum SocialImage {
        static let instagram = "InstagramIcon"
        static let soop = "SoopIcon"
        static let youtube = "YoutubeIcon"
        static let x = "XIcon"
    }
    
    enum ErrorImage: String {
        case noData = "NoData"
        case notWak = "NotWak"
        case noVideo = "NoVideo"
        case darkNoData = "DarkNoData"
        case lightNoData = "LightNoData"
    }
    
    enum ButtonImage {
        static let backButton = "BackBlack"
        static let closeButton = "closeRounded"
    }
    
    enum SettingViewImage {
        static let guiduDark = "GuiduDark"
        static let guiduLight = "GuiduLight"
    }
    
    enum backImage {
        static let splash1 = "Splash1"
        static let defaultBack = "DefaultBack"
    }
    
    enum LogoImage {
        static let stepLogo = "stepLogo"
        static let appLogo = "AppLogo"
    }
    
    enum OnBoardingImage: String, CaseIterable {
        case first = "Page1"
        case second = "Page2"
        case third = "Page3"
        case fore = "Page4"
    }
    
    enum OtherImage {
        static let ask = "Ask"
        static let chevronDown = "Chevron_Down"
        static let chevronUp = "Chevron_Up"
        static let clock = "Clock"
        static let dropDownButton = "DropDownButton"
        static let palette = "Palette"
        static let users = "Users"
    }
}
