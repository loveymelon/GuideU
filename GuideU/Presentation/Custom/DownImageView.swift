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
                CGSize(width: 300, height: 300)
            case .mid:
                CGSize(width: 200, height: 200)
            case .min:
                CGSize(width: 100, height: 100)
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
