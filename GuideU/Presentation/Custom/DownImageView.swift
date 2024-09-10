//
//  DownImageView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/30/24.
//

import SwiftUI
import Kingfisher

struct DownImageView: View {
    
    @State private var currentURL: URL? = nil
    
    let url: URL?
    let option: Option
    var fallbackURL: URL? = nil
    
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
        VStack {
            if currentURL != nil {
                KFImage(currentURL)
                    .setProcessor(
                        DownsamplingImageProcessor(
                            size: option.size
                        )
                    )
                    .onFailure { error in
                        print(error)
                        if case .imageSettingError(reason: .emptySource) = error {
                            currentURL = url
                        } else if let fallbackURL {
                            currentURL = fallbackURL
                        }
                    }
                    .cacheOriginalImage()
                    .resizable()
            }
        }
        .onAppear {
            currentURL = url ?? fallbackURL
        }
    }
}

#if DEBUG
#Preview {
    DownImageView(
        url: URL(string: "https://yt3.googleusercontent.com/TfNiEYiPS4wX6BWXerod80xL3pB8RvRLHiEDiPTPo1ZOIsgYivENAGTu2Sax_YJ-8g9SCHtvFw=s176-c-k-c0x00ffffff-no-rj"),
        option: .max,
        fallbackURL: URL(string: "https://photo.waksight.com/%EC%9A%B0%EC%99%81%EA%B5%B3%EC%9D%B4%EC%84%B8%EB%8F%8C/%EB%A6%B4%ED%8C%8C-%ED%8E%BC%EC%B9%98%EA%B8%B0.png")
    )
}
#endif
