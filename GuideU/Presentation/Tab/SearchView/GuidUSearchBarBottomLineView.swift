//
//  GuidUSearchBarBottomLineView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/31/24.
//

import SwiftUI

struct GuidUSearchBarBottomLineView: View {
    @Binding
    var currentText: String
    @EnvironmentObject var colorSystem: ColorSystem
    
    let placeHolder: String
    let lineWidth: CGFloat
    var onSubmit: () -> Void
   
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                TextField(placeHolder, text: $currentText)
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                    .onSubmit {
                        onSubmit()
                    }
                
                Image(.search)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 25)
                    .asButton {
                        onSubmit()
                    }
            }
            .padding(.bottom, 5)

            Divider()
                .frame(height: lineWidth)
                .overlay(Color(GuideUColor.ViewBaseColor.light.primary))
        }
    }
}


