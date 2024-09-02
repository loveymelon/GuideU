//
//  ResultCase.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/2/24.
//

import Foundation

enum ResultCase {
    case character
    case meme
    
    var title: String {
        return switch self {
        case .character:
            "인물"
        case .meme:
            "밈"
        }
    }
}
