//
//  ResultCase.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/2/24.
//

import Foundation

enum ResultCase: String {
    case character = "character"
    case meme = "meme"
    
    var title: String {
        switch self {
        case .character:
            "인물"
        case .meme:
            "밈"
        }
    }
}
