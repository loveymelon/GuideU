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
        VStack {
            GeometryReader {
                let safeArea = $0.safeAreaInsets
                
                GeometryReader { geometry in
                    let size = geometry.size
                    let minY = geometry.frame(in: .named("SCROOL")).minY
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            headerView(size: size, safeArea: safeArea)
                                .zIndex(1000)
                            LazyVStack {
                                ForEach(1...100, id: \.self) { num in
                                    HStack {
                                        Text(String(num))
                                    }
                                }
                            }
                            .frame(width: size.width)
                        }
                        .background {
                            ScrollDetector { offset in
                                offsetY = -offset
                            } onDraggingEnd: { offset, veloc in
                                
                            }
                        }
                        .zIndex(1000)
                    }
                    .toolbar(.hidden, for: .navigationBar)
                }
                .ignoresSafeArea(.all, edges: .top)
            }
        }
    }
    
    @ViewBuilder
    func headerView(size: CGSize, safeArea: EdgeInsets) -> some View {
        let headerHeight = (size.height * 0.26) + safeArea.top
        let minHeight = 70 + safeArea.top
        let changeHeight = (headerHeight + offsetY)
        
        GeometryReader { proxy in
            let size = proxy.size
                backgroundImage(size: size, minY: offsetY)
                    .offset(y: -offsetY)
                    .frame(height: changeHeight < minHeight ? minHeight : changeHeight, alignment: .bottom)
            
                fakeNavigation(size: size)
                    .padding(.top, safeArea.top + 10)
                    .offset(y: -offsetY)
            
        }
        .frame(height: headerHeight)
    }
    
    private func backgroundImage(size: CGSize, minY: CGFloat) -> some View {
        Group {
            /// 조건에 따라 이미지 변경할것.
            Image.defaultBack.resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height + (minY > 0 ? minY : 0))
                .clipped()
        }
        .blur(radius: 20, opaque: true)
        .opacity(0.4)
        .background(.white)
    }
    
    private func fakeNavigation(size: CGSize)  -> some View {
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
        .padding(.horizontal, 10)
    }
}

#if DEBUG
#Preview {
    HomeView()
}
#endif
