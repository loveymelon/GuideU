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
    
    func styledText(fullFont: UIFont, fullColor: UIColor, targetString: String, targetFont: UIFont, targetColor: UIColor) -> AttributedString {
        var attributedString = AttributedString(self)
        
        // 전체 문자열의 기본 폰트와 색상 설정
        attributedString.font = fullFont
        attributedString.foregroundColor = fullColor
        
        // 특정 문자열에 대한 폰트와 색상 설정
        if let range = attributedString.range(of: targetString) {
            attributedString[range].font = targetFont
            attributedString[range].foregroundColor = targetColor
        }
        return attributedString
    }
    
    /// 문자열(폰트에 따른) 의 전체 사이즈를 계산합니다.
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size
    }
}

extension String: Error { }
