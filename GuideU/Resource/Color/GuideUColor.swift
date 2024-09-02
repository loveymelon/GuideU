//
//  GuideUColor.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/12/24.
//

import SwiftUI

enum GuideUColor{
    
    enum tabbarColor: String {
        case light
        case dark
        
        var color: UIColor {
            switch self {
            case .light:
                return  UIColor(red: 248 / 255, green: 248 / 255, blue: 248 / 255, alpha: 1)
            case .dark:
                return UIColor(red: 76 / 255, green: 75 / 255, blue: 74 / 255, alpha: 1)
            }
        }
    }
    
    enum ViewBaseColor: String {
        case light
        case dark
        
        var backColor: UIColor {
            switch self {
            case .light:
                return UIColor(hexCode: "FFFFFF")
            case .dark:
                return UIColor(hexCode: "252525")
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .light:
                return UIColor(hexCode: "0D0D0D")
            case .dark:
                return UIColor(hexCode: "F8F8F8")
            }
        }
        
        var gray1: UIColor {
            switch self {
            case .light:
                return UIColor(hexCode: "4C4B4A")
            case .dark:
                return UIColor(hexCode: "E1E1E1")
            }
        }
        
        var gray2: UIColor {
            switch self {
            case .light:
                return UIColor(hexCode: "7F7E7D")
            case .dark:
                return UIColor(hexCode: "C0C0C0")
            }
        }
        
        var gray3: UIColor {
            switch self {
            case .light:
                return UIColor(hexCode: "E1E1E1")
            case .dark:
                return UIColor(hexCode: "7F7E7D")
            }
        }
        
        var depth1: UIColor {
            switch self {
            case .light:
                return UIColor(hexCode: "F8F8F8")
            case .dark:
                return UIColor(hexCode: "4C4B4A")
            }
        }
        
        var stroke: UIColor {
            switch self {
            case .light:
                return UIColor(hexCode: "000000", alpha: 10)
            case .dark:
                return UIColor(hexCode: "FFFFFF", alpha: 10)
            }
        }
        
        var mainBlur: UIColor {
            switch self {
            case .light:
                return UIColor(hexCode: "FAFAFA", alpha: 90)
            case .dark:
                return UIColor(hexCode: "151515", alpha: 95)
            }
        }
        
        var primary: UIColor {
            return UIColor(hexCode: "#00ddbb", alpha: 1)
        }
        
        var interaction6: UIColor {
            return UIColor(hexCode: "#00b196", alpha: 1)
        }
        
        
        var pinkType: UIColor {
            switch self {
            case .light:
                return UIColor(hexCode: "#FFD2CF", alpha: 1)
            case .dark:
                return UIColor(hexCode: "#FFD2CF", alpha: 1)
            }
        }
        
        var darkPinkType: UIColor {
            switch self {
            case .light:
                return UIColor(hexCode: "#5D1615", alpha: 1)
            case .dark:
                return UIColor(hexCode: "#5D1615", alpha: 1)
            }
        }
        
        var greenType: UIColor {
            switch self {
            case .light:
                return UIColor(hexCode: "#DBEDDB", alpha: 1)
            case .dark:
                return UIColor(hexCode: "#DBEDDB", alpha: 1)
            }
        }
        
        var darkGreenType: UIColor {
            switch self {
            case .light:
                return UIColor(hexCode: "#1D3829", alpha: 1)
            case .dark:
                return UIColor(hexCode: "#1D3829", alpha: 1)
            }
        }
    }
    
}
