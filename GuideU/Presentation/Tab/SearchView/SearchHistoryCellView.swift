//
//  SearchHistoryCellView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/1/24.
//

import SwiftUI

/// NeedToModel : Name( String )
struct SearchHistoryCellView: View {
    
    let name: String
    
    var removeTapped: () -> Void
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image(ImageType.TabImage.NormalImage.history)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 36)
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                
                Text(name)
                    .font(Font(WantedFont.regularFont.font(size: 16)))
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                Spacer()
                
                Image(ImageType.ButtonImage.closeButton)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 22)
                    .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
                    .onTapGesture {
                        removeTapped()
                    }
            }
            .padding(.vertical, 8)
        }
    }
}

#if DEBUG
#Preview {
    SearchHistoryCellView(name: "빅토리") {
        
    }
}
#endif
