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
        
        let lowerCaseSelf = self.lowercased()
        
        targetTexts.forEach { targetString in
            let lowerCaseTarget = targetString.lowercased()
            var searchRange = lowerCaseSelf.startIndex..<lowerCaseSelf.endIndex
            
            while let foundRange = lowerCaseSelf.range(of: lowerCaseTarget, range: searchRange) {
                
                if let attributedRange = Range(foundRange, in: attributedString) {
                    attributedString[attributedRange].font = targetFont
                    attributedString[attributedRange].foregroundColor = targetColor
                }
                
                searchRange = foundRange.upperBound..<lowerCaseSelf.endIndex
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
