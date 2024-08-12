//
//  ExFont.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/12/24.
//

import SwiftUI

extension Font {
    enum WantedFont: String {
        case blackFont = "WantedSans-Black"
        case boldFont = "WantedSans-Bold"
        case extraBlack = "WantedSans-ExtraBlack"
        case extraBold = "WantedSans-ExtraBold"
        case midFont = "WantedSans-Medium"
        case regularFont = "WantedSans-Regular"
        case semiFont = "WantedSans-SemiBold"
        
        func font(size: CGFloat) -> Font {
            return Font.custom(self.rawValue, size: size)
        }
    }
}

