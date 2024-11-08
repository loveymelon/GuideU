//
//  ScrollOffsetHiddenView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 11/8/24.
//

import SwiftUI

struct ScrollOffsetHiddenView: View {
    
    @State var totalHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            let offsetY = proxy.frame(in: .global).origin.y
            Color.clear
                .preference(
                    key: ScrollOffsetKey.self,
                    value: offsetY
                )
                .onAppear {
                    print(proxy.size.height)
                }
        }
        .frame(height: 0)
    }
}
