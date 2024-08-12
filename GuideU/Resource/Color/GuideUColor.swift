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
    
}
