//
//  BottomPopView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/19/24.
//

import SwiftUI

struct BottomPopView : View {
    var detail: String = ""
    let backColor: Color
    
    var body: some View {
        VStack(spacing: 0) {
            Text(detail)
                .font(.system(size: 15))
                .foregroundStyle(.black)
        }
        .padding(16)
        .background(backColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 8)
        .padding(.horizontal, 16)
    }
}
