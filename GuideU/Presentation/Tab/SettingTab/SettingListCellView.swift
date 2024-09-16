//
//  SettingListCellView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/16/24.
//

import SwiftUI

struct SettingListCellView: View {
    
    let setModel: SettingCase
    
    var body: some View {
        HStack {
            if let imageString = setModel.logoImage {
                Image(imageString)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 22)
                    .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.gray1))
            }
            Text(setModel.title)
                .font(Font(WantedFont.semiFont.font(size: 20)))
                .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.gray1))
                Spacer()
            if case let .theme = setModel {
                // 테마 설정
                
            }
            Text(setModel.subTitle)
                .font(Font(WantedFont.midFont.font(size: 16)))
                .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.gray2))
        }
    }
}
