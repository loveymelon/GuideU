//
//  MoreCharacterListView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/30/24.
//

import SwiftUI
import Alamofire

struct MoreCharacterListView: View {
    
    @EnvironmentObject var colorSystem: ColorSystem
    
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
        .background(colorSystem.color(colorCase: .cellBackground))
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
                Text(Const.ready)
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
                        .lineLimit(2)
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
