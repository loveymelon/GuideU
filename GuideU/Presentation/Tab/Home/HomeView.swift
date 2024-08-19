//
//  HomeView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/19/24.
//

import SwiftUI

struct HomeView: View {
    
    @State
    private var offsetY: CGFloat = 0
    
    var body: some View {
        GeometryReader{ geometry in
            let size = geometry.size
            let safeArea = geometry.safeAreaInsets
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    HeaderView(parentSize: size, safeArea: safeArea, view: {
                        HeaderContentView()
                    }, nav: {
                        fakeNavigationView()
                    }, offsetY: $offsetY)
                        .offset(y: -offsetY) // 상단고정
                        .zIndex(1000)
                    LazyVStack {
                        
                    }
                }
                .background {
                    ScrollDetector { offset in
                        print("offset: \(-offset) ")
                        offsetY = -offset
                    } onDraggingEnd: { offset, velocity in
                        print("offset: \(offset), velocity: \(velocity)")
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .toolbar(.hidden, for: .navigationBar)
        
    }
    
    private func fakeNavigationView() -> some View {
        HStack {
            Image.appLogo.resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 52, height: 52)

            Spacer()
            
            Image.search.resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 32, height: 32)
                .asButton {
                    
                }
        }
        .padding(.trailing, 10)
        .padding(.leading, 4)
    }
}

#if DEBUG
#Preview {
    HomeView()
}
#endif
