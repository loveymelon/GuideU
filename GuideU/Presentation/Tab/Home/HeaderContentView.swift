//
//  HeaderContentView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/19/24.
//

import SwiftUI

struct HeaderContentView: View {
    
    var body: some View {
        GeometryReader { geo in
            Image.defaultBack
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 30, opaque: true)
                .opacity(0.3)
                .frame(width: geo.size.width)
        }
    }
}

#if DEBUG
#Preview {
    HomeView()
}
#endif
