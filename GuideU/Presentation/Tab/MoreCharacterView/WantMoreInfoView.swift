//
//  WantMoreInfoView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/30/24.
//

import SwiftUI

struct WantMoreInfoView: View {

    @EnvironmentObject var colorSystem: ColorSystem
    
    @Binding var currentDropDownIndex: Int
    
    @State private var dropdown = false
    
    let dropDownOptions: [Const.Channel]
    
    var body: some View {
        VStack(spacing: 0) {
            Text(
                Const.wantMain.styledText(
                    fullFont: WantedFont.regularFont.font(size: 22),
                    fullColor: UIColor(colorSystem.color(colorCase: .textColor)),
                    targetString: Const.wantTarget,
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
                
                Text(Const.wantSub)
                    .font(Font(WantedFont.regularFont.font(size: 22)))
                    .padding(.top, 10)
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
            }
        }
    }
}
