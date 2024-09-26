//
//  CurrentColorModeCase.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/24/24.
//

import Foundation

enum CurrentColorModeCase: Int, CaseIterable, Equatable {
    case system = 0
    case light = 1
    case dark = 2
    
    var title: String {
        return switch self {
        case .system:
            "시스템"
        case .light:
            "라이트 모드"
        case .dark:
            "다크 모드"
        }
    }
}
