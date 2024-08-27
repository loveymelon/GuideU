//
//  GuideUSearchBarView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/27/24.
//

import SwiftUI

struct GuideUSearchBarView: View {
    
    @Binding
    var currentText: String
    
    let placeHolder: String
    let lineWidth: CGFloat
   
    var body: some View {
        VStack {
            VStack {
                TextField(placeHolder, text: $currentText)
                    .padding(.all, 14)
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color(GuideUColor.ViewBaseColor.light.primary), lineWidth: lineWidth)
            }
        }
    }
}

