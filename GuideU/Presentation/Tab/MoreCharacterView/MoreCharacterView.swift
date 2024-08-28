//
//  MoreCharacterView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/28/24.
//

import SwiftUI

struct MoreCharacterView: View {
    @State
    var currentText = ""
    @State
    var currentIndex = 0
    
    private let text0 =  "알고싶은 왁타버스 영상을 여기에"
    private let text1 = "나는 왁타버스에서"
    private let text2 = "을 더 알아보고 싶어요."
    
    var body: some View {
        contentView()
    }
}

extension MoreCharacterView {
    private func contentView() -> some View {
        VStack {
            GuideUSearchBarView(currentText: $currentText, placeHolder: text0, lineWidth: 1.4) {
                print(currentText)
            }
            .padding(.horizontal, 10)
            
            ScrollView {
                wantMoreInfoView()
                    .padding(.top, 5)
                    .padding(.vertical, 10)
            }
        }
    }
    
    private func wantMoreInfoView() -> some View {
        VStack(spacing: 0) {
            Text(
                text1.styledText(
                    fullFont: WantedFont.regularFont.font(size: 22),
                    fullColor: .black,
                    targetString: "왁타버스",
                    targetFont: WantedFont.boldFont.font(size: 24),
                    targetColor: GuideUColor.ViewBaseColor.light.primary
                )
            )
            
            HStack {
                DropDownMenu(options: ["아이네","주루루"], selectedOptionIndex: $currentIndex)
                    .frame(width: 130)
                Text(text2)
                    .font(Font(WantedFont.semiFont.font(size: 22)))
            }
        }
    }
}

#if DEBUG
#Preview {
    MoreCharacterView()
}
#endif
