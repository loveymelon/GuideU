//
//  SettingListCellView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/16/24.
//

import SwiftUI

struct SettingListCellView: View {
    
    let setModel: SettingCase
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        HStack {
            if let imageString = setModel.logoImage {
                Image(imageString)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 22)
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
            }
            Text(setModel.title)
                .font(Font(WantedFont.semiFont.font(size: 20)))
                .foregroundStyle(colorSystem.color(colorCase: .textColor))
                Spacer()
            
            Group {
                if setModel == .theme {
                    Text(colorSystem.currentColorSet.title)
                } else {
                    Text(setModel.subTitle)
                }
            }
            .font(Font(WantedFont.midFont.font(size: 16)))
            .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
        }
    }
}
