//
//  SearchResultCaseView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/2/24.
//

import SwiftUI

struct SearchResultCaseView: View {
    
    let currentText: String
    let setModel: SuggestEntity
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        HStack {
            Text(setModel.keyWord.styledText(fullFont: WantedFont.regularFont.font(size: 18), fullColor: UIColor(colorSystem.color(colorCase: .textColor)), targetString: currentText, targetFont: WantedFont.regularFont.font(size: 18), targetColor: UIColor(colorSystem.color(colorCase: .pointColor))))
            
            Spacer()
            
            caseOfView()
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

extension SearchResultCaseView {
    
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
    SearchResultCaseView(currentText: "우", setModel: .init(type: .character, keyWord: "우왁굳"))
}
#endif
