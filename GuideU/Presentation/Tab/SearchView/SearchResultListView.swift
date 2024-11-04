//
//  SearchResultListView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/7/24.
//

import SwiftUI

struct SearchResultListView: View {
    
    let setModel: SearchResultEntity
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        VStack(alignment: .leading ,spacing: 0) {
            HStack {
                Text(setModel.name)
                    .font(Font(WantedFont.semiFont.font(size: 20)))
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                caseOfView()
                Spacer()
            }
            .padding(.bottom, 6)
            Text(setModel.mean ?? "")
                .font(Font(WantedFont.midFont.font(size: 14)))
                .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
                .lineLimit(1)
        }
    }
    
    private func caseOfView() -> some View {
        Text(setModel.resultType.title)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background {
                switch setModel.resultType {
                case .character:
                    Color(GuideUColor.ViewBaseColor.light.pinkType)
                case .meme:
                    Color(GuideUColor.ViewBaseColor.light.greenType)
                }
            }
            .foregroundStyle(colorSet())
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .font(Font(WantedFont.regularFont.font(size: 15)))
    }
}

extension SearchResultListView {
    
    private func colorSet() -> Color {
        switch setModel.resultType {
        case .character:
            return Color(GuideUColor.ViewBaseColor.light.darkPinkType)
        case .meme:
            return Color(GuideUColor.ViewBaseColor.light.darkGreenType)
        }
    }
}
