//
//  SearchResultListView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/7/24.
//

import SwiftUI

struct SearchResultListView: View {
    
    let setModel: SearchResultListEntity
    
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
            Text(setModel.definition)
                .font(Font(WantedFont.midFont.font(size: 14)))
                .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
                .lineLimit(1)
        }
    }
    
    private func caseOfView() -> some View {
        Text(setModel.type.title)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background {
                switch setModel.type {
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
        switch setModel.type {
        case .character:
            return Color(GuideUColor.ViewBaseColor.light.darkPinkType)
        case .meme:
            return Color(GuideUColor.ViewBaseColor.light.darkGreenType)
        }
    }
}

#if DEBUG
#Preview {
    SearchResultListView(setModel: .init(name: "우왁굳", type: .character, definition: "우왁굳은 대한민국의 트위치 파트너 스트리머, 유튜브 크리에이터, 작사가 임과 동시에 이세계아이돌의 총괄 프로듀서이자 왁 엔터테인먼트의 설립자이다."))
        .environmentObject(ColorSystem())
}

#endif
