//
//  SocialType.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/11/24.
//

import Foundation

enum SocialType: String, CaseIterable {
    case youtube
    case instagram
    case twitter
    case afreeca
    case naverCafe
    
    var checkerText: [String] {
        return switch self {
        case .youtube:
            ["youtube.com", "youtu.be"]
        case .instagram:
            ["instagram.com"]
        case .twitter:
            ["twitter.com", "x.com"]
        case .afreeca:
            ["afreecatv.com"]
        case .naverCafe:
            ["naver.com"]
        }
    }
    
    func containsTarget(_ target: String) -> Bool {
        checkerText.contains(where: { target.contains($0)})
    }
    
    static func getCase(_ target: String) -> Self? {
        for type in SocialType.allCases {
            if type.containsTarget(target) {
                return type
            }
        }
        return nil
    }
}
