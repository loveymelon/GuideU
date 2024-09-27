//
//  SearchResultRelatedView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/19/24.
//

import SwiftUI

struct SearchResultRelatedView: View {
    let setModel: RelatedVideoEntity
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        contentView()
    }
}


extension SearchResultRelatedView {
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
        DownImageView(url: setModel.thumbnailURL, option: .custom(CGSize(width: 400, height: 200)))
            .aspectRatio(contentMode: .fill)
            .frame(height: 190)
            .clipped()
    }
    
    private func sectionView() -> some View {
        HStack {
            VStack(spacing: 4) {
                HStack {
                    Text(setModel.title)
                        .multilineTextAlignment(.leading)
                        .font(Font(WantedFont.boldFont.font(size: 15)))
                        .foregroundStyle(colorSystem.color(colorCase: .textColor))
                    Spacer()
                }
                HStack {
                    Text(setModel.channel)
                        .font(Font(WantedFont.midFont.font(size: 12)))
                        .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
                    Spacer()
                }
            }
        }
    }
}
