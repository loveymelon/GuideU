//
//  DownImageView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/30/24.
//

import SwiftUI
import Kingfisher

struct DownImageView: View {
    
    let url: URL?
    let option: Option
    
    enum Option {
        case max
        case mid
        case min
        case custom(CGSize)
        
        var size: CGSize {
            return switch self {
            case .max:
                CGSize(width: 180, height: 180)
            case .mid:
                CGSize(width: 120, height: 120)
            case .min:
                CGSize(width: 80, height: 80)
            case let .custom(size):
                size
            }
        }
    }
    
    var body: some View {
        KFImage(url)
            .setProcessor(
                DownsamplingImageProcessor(
                    size: option.size
                )
            )
            .cacheOriginalImage()
            .resizable()
    }
}
