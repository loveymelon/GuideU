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
    
    func styledText(fullFont: UIFont, fullColor: UIColor, targetString: String, targetFont: UIFont, targetColor: UIColor) -> AttributedString {
        var attributedString = AttributedString(self)
        
        // 전체 문자열의 기본 폰트와 색상을 설정합니다.
        attributedString.font = fullFont
        attributedString.foregroundColor = fullColor
        
        // targetString의 공백 제거 및 대소문자 구분 없이 비교
        let targetStringNormalized = targetString.trimmingCharacters(in: .whitespacesAndNewlines)
        let originalStringNormalized = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 특정 문자열에 대한 폰트와 색상을 설정
        if let range = originalStringNormalized.range(of: self) {
            let nsRange = NSRange(range, in: targetStringNormalized)
            if let attributedRange = Range(nsRange, in: attributedString) {
                attributedString[attributedRange].font = targetFont
                attributedString[attributedRange].foregroundColor = targetColor
            }
        }

        return attributedString
    }
}

extension String: Error { }
