//
//  MoreCharacterListView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/30/24.
//

import SwiftUI
import Alamofire

struct MoreCharacterListView: View {
    
    @Environment(\.colorSystem) var colorSystem
    
    let setModel: VideosEntity
    
    var body: some View {
        contentView()
    }
}

extension MoreCharacterListView {
    private func contentView() -> some View {
        VStack {
            mainImageView()
            sectionView()
                .padding(.horizontal, 10)
                .padding(.bottom, 8)
        }
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 6)
    }
    
    private func mainImageView() -> some View {
        DownImageView(url: setModel.videoImageURL, option: .custom(CGSize(width: 400, height: 200)))
            .aspectRatio(contentMode: .fill)
            .frame(height: 190)
            .clipped()
    }
    
    private func sectionView() -> some View {
        HStack {
            if let url = setModel.channelImageURL {
                DownImageView(url: url, option: .min)
                .frame(width: 40, height: 40)
                .aspectRatio(1, contentMode: .fill)
                .clipShape(Circle())
            } else {
                Text("준비중")
                    .font(Font(WantedFont.boldFont.font(size: 12)))
                    .foregroundStyle(Color(GuideUColor.ViewBaseColor.dark.textColor))
                    .frame(width: 40, height: 40)
                    .aspectRatio(1, contentMode: .fill)
                    .background(colorSystem.color(colorCase: .pointColor))
                    .clipShape(Circle())
            }
            
            VStack(spacing: 4) {
                HStack {
                    Text(setModel.title)
                        .multilineTextAlignment(.leading)
                        .font(Font(WantedFont.boldFont.font(size: 15)))
                        .foregroundStyle(colorSystem.color(colorCase: .textColor))
                    Spacer()
                }
                HStack {
                    Text(setModel.channelName)
                        .font(Font(WantedFont.midFont.font(size: 12)))
                        .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
                    Spacer()
                }
                
            }
        }
    }
    
}
//#if DEBUG
//#Preview  {
//    MoreCharacterListView(setModel: .init(
//        videoURL: URL(string: "https://www.youtube.com/watch?v=A77QDU3GC6Y"),
//        channelName: "징버거가 ZZANG센 주제에 너무 신중하다",
//        videoImageURL: URL(string: "https://i.ytimg.com/vi/A77QDU3GC6Y/sddefault.jpg"),
//        updatedAt: Date(),
//        channelImageURL: URL(string: "https://yt3.googleusercontent.com/ROy3xGFEsnCJtxG-dtb48RM51Z_GKwpIh2n76wr6XH0YQHAOJ-jYxVaWio-I43JyRCe6oOykdA=s160-c-k-c0x00ffffff-no-rj"),
//        title: "상당히 갑작스럽게 진행된 다이진희쇼"
//    ))
//}
//#endif
