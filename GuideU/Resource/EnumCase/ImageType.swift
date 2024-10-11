//
//  ImageType.swift
//  GuideU
//
//  Created by 김진수 on 10/11/24.
//

import Foundation

enum ImageType {
    enum TabImage {
        enum SelectImage: String {
            case home = "HomeTabSelected"
            case search = "SearchTab"
            case history = "HistoryTabSelected"
            case setting = "SettingTabSelected"
            case meme = "MemeSeletedTab"
        }
        
        enum NormalImage: String {
            case home = "HomeTab"
            case search = "SearchTabDis"
            case history = "HistoryTab"
            case setting = "SettingTab"
            case meme = "MemeTab"
        }
    }
    
    enum SocialImage: String {
        case instagram = "InstagramIcon"
        case soop = "SoopIcon"
        case youtube = "YoutubeIcon"
        case x = "XIcon"
    }
    
    enum ErrorImage: String {
        case noData = "NoData"
        case notWak = "NotWak"
        case noVideo = "NoVideo"
        case darkNoData = "DarkNoData"
        case lightNoData = "LightNoData"
    }
    
    enum ButtonImage: String {
        case backButton = "BackBlack"
        case closeButton = "closeRounded"
    }
    
    enum SettingViewImage: String {
        case guiduDark = "GuiduDark"
        case guiduLight = "GuiduLight"
    }
    
    enum backImage: String {
        case splash1 = "Splash1"
        case defaultBack = "DefaultBack"
    }
    
    enum LogoImage: String {
        case stepLogo = "stepLogo"
        case appLogo = "AppLogo"
    }
    
    enum OnBoardingImage: String, CaseIterable {
        case first = "Page1"
        case second = "Page2"
        case third = "Page3"
        case fore = "Page4"
    }
    
    enum OtherImage: String {
        case ask = "Ask"
        case chevronDown = "Chevron_Down"
        case chevronUp = "Chevron_Up"
        case clock = "Clock"
        case dropDownButton = "DropDownButton"
        case palette = "Palette"
        case users = "Users"
    }
}
