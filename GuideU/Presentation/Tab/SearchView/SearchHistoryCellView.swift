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
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image.history
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 36)
                    .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.gray2))
                
                Text(name)
                    .font(Font(WantedFont.regularFont.font(size: 16)))
                Spacer()
                
                Image.close
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 22)
                    .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.gray2))
                    .asButton {
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
