//
//  WantMoreInfoView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/30/24.
//

import SwiftUI

struct WantMoreInfoView: View {
    
    private let placeHolder =  "알고싶은 왁타버스 영상을 여기에"
    private let main = "나는 왁타버스에서"
    private let sub = "을 더 알아보고 싶어요."
    private let targetString = "왁타버스"

    @EnvironmentObject var colorSystem: ColorSystem
    
    @Binding var currentDropDownIndex: Int
    
    @State private var dropdown = false
    
    let dropDownOptions: [Const.Channel]
    
    var body: some View {
        VStack(spacing: 0) {
            Text(
                main.styledText(
                    fullFont: WantedFont.regularFont.font(size: 22),
                    fullColor: UIColor(colorSystem.color(colorCase: .textColor)),
                    targetString: targetString,
                    targetFont: WantedFont.boldFont.font(size: 24),
                    targetColor: GuideUColor.ViewBaseColor.light.primary
                )
            )
            
            HStack(alignment: .top, spacing: 4) {
                DropDownMenu(
                    options: dropDownOptions.map(
                        {
                            $0.menuTitle
                        }),
                    selectedOptionIndex: $currentDropDownIndex,
                    showDropdown: $dropdown
                )
                .frame(width: 110)
                .environmentObject(colorSystem)
                .zIndex(100)
                
                Text(sub)
                    .font(Font(WantedFont.regularFont.font(size: 22)))
                    .padding(.top, 10)
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
            }
        }
    }
}
