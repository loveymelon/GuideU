//
//  HomeView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/19/24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let safeArea = geometry.safeAreaInsets
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    headerView(size: size, safeArea: safeArea)
                }
                .zIndex(1000)
                .background {
                    ScrollDetector { offset in
                        offsetY = offset
                    } onDraggingEnd: { offset, velocity in
                        
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .top)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    @ViewBuilder
    func headerView(size: CGSize, safeArea: EdgeInsets) -> some View {
        let headerHeight = (size.height * 0.26) + safeArea.top
        
        ZStack {
            /// 배경 이미지
            Image.defaultBack.resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 20, opaque: true)
                .opacity(0.3)
                .frame(height: headerHeight) // 배경의 높이 설정
            
            GeometryReader { _ in
                fakeNavigation()
                    .padding(.top, safeArea.top)
                    .frame(width: size.width)
            }
        }
        .frame(height: headerHeight)
        .offset(y: offsetY)
    }
    
    private func fakeNavigation() -> some View {
        HStack {
            Image.appLogo
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: 52)
            
            Spacer()
            
            Image.search
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: 32)
        }
        .padding(.trailing, 10)
        .padding(.leading, 10)
    }
}

#if DEBUG
#Preview {
    HomeView()
}
#endif
