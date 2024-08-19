//
//  HeaderView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/19/24.
//

import SwiftUI

struct HeaderView<V: View, N: View>: View {

    var parentSize: CGSize
    var safeArea: EdgeInsets
    var view: () -> V
    var nav: () -> N
    
    @Binding var offsetY: CGFloat
    
    var body: some View {
        contentView()
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        let headerHeight = (parentSize.height * 0.3) + safeArea.top
        let minHeight = 50 + safeArea.top
        let ifHeight = headerHeight + offsetY
        
        GeometryReader { _ in
            ZStack(alignment: .top) {
                Spacer().frame(height: 1)
                nav()
                    .padding(.top, safeArea.top)
                view()
            }
            .frame(height: ifHeight < minHeight ? minHeight : ifHeight, alignment: .bottom)
        }
        .frame(height: headerHeight)
    }
}

#if DEBUG
#Preview {
   HomeView()
}
#endif
