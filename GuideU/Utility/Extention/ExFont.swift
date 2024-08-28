//
//  ExFont.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/12/24.
//

import SwiftUI

enum WantedFont: String {
    case blackFont = "WantedSans-Black"
    case boldFont = "WantedSans-Bold"
    case extraBlack = "WantedSans-ExtraBlack"
    case extraBold = "WantedSans-ExtraBold"
    case midFont = "WantedSans-Medium"
    case regularFont = "WantedSans-Regular"
    case semiFont = "WantedSans-SemiBold"
    
    func font(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

