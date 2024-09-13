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
    var ifNeedFailTrigger: (() -> Void)?
    
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
                        ifNeedFailTrigger?()
                        currentURL = fallbackURL
                    }
                }
                .loadDiskFileSynchronously(false) // 동기적 디스크 호출 안함
                .cancelOnDisappear(true) // 사라지면 취소
                .diskCacheExpiration(.days(7))  // 7일 후 디스크 캐시에서 만료
                .backgroundDecode(true) // 백그라운드에서 디코딩
                .fade(duration: 0.38)
                .resizable()
        } else {
            Color.clear
                .onAppear {
                    currentURL = url ?? fallbackURL
                }
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
