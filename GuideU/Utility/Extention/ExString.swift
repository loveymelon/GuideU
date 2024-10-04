//
//  ExString.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/28/24.
//

import UIKit

extension String {
    
    var toDate: Date? {
        return DateManager.shared.toDate(self)
    }
    
    func toDate(dateFormat: DateManager.dateFormatType ) -> String {
        return DateManager.shared.toDate(self, format: dateFormat)
    }
    
    func styledText(fullFont: UIFont, fullColor: UIColor, targetTexts: [String], targetFont: UIFont, targetColor: UIColor) -> AttributedString {
        
        var attributedString = AttributedString(self)
        
        attributedString.font = fullFont
        attributedString.foregroundColor = fullColor
        
        targetTexts.forEach { targetString in
            if let range = attributedString.range(of: targetString) {
                attributedString[range].font = targetFont
                attributedString[range].foregroundColor = targetColor
            }
        }
        
        return attributedString
    }
    
    func styledText(fullFont: UIFont, fullColor: UIColor, targetString: String, targetFont: UIFont, targetColor: UIColor) -> AttributedString {
        return styledText(fullFont: fullFont, fullColor: fullColor, targetTexts: [targetString], targetFont: targetFont, targetColor: targetColor)
    }
    
    /// 문자열(폰트에 따른) 의 전체 사이즈를 계산합니다.
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size
    }
}

extension String: @retroactive Error { }
