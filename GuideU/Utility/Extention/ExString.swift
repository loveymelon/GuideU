//
//  ExString.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/28/24.
//

import UIKit

extension String {
    
    func styledText(fullFont: UIFont, fullColor: UIColor, targetString: String, targetFont: UIFont, targetColor: UIColor) -> AttributedString {
        var attributedString = AttributedString(self)
        
        // 전체 문자열의 기본 폰트와 색상을 설정합니다.
        attributedString.font = fullFont
        attributedString.foregroundColor = fullColor
        
        // 특정 문자열에 대한 폰트와 색상을 설정합니다.
        if let range = attributedString.range(of: targetString) {
            attributedString[range].font = targetFont
            attributedString[range].foregroundColor = targetColor
        }
        return attributedString
    }
}
