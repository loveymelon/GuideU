//
//  HomeView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/19/24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var offsetY: CGFloat = 0
    
    private let entity = HeaderEntity(title: "이세계아이돌", channelName: "우왁굳의 게임방송", time: "08:30")
    
    var body: some View {
        VStack {
            GeometryReader {
                let safeArea = $0.safeAreaInsets
                
                GeometryReader { geometry in
                    let size = geometry.size
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
        let progress = max(min(-offsetY / (headerHeight - minHeight), 1), 0)
        let opacity = 0.8 + (offsetY / 100)
        
        GeometryReader { proxy in
            let size = proxy.size
            backgroundImage(size: size, minY: offsetY)
                .offset(y: -offsetY)
                .frame(height: changeHeight < minHeight ? minHeight : changeHeight, alignment: .bottom)
            
            VStack(spacing: 20) {
                fakeNavigation(size: size, entity: entity, opacity: -opacity)
                    .padding(.top, safeArea.top + 10)
                    .offset(y: -offsetY)
                    .zIndex(3000)
                headerContentView(size: size, entity: entity)
                    .opacity(opacity)
            }
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
        .blur(radius: 40, opaque: true)
        .opacity(0.2)
        .background(.white)
    }
    
    private func fakeNavigation(size: CGSize, entity: HeaderEntity, opacity: CGFloat)  -> some View {
        ZStack {
            HStack {
                Image.appLogo
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 52)
                    
                Text(entity.title)
                    .font(.WantedFont.boldFont.font(size: 23))
                    .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.primary))
                    .frame(maxWidth: .infinity)
                    .opacity(opacity)
                
                VStack {
                    Image.search
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: 32)
                }
                .frame(width: 52)
            }
        }
        .padding(.leading, 10)
    }
    
    private func headerContentView(size: CGSize, entity: HeaderEntity) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entity.sectionTitle)
                .font(.WantedFont.midFont.font(size: 16))
                .padding(.bottom, 4)
            
            Text(entity.title)
                .font(.WantedFont.boldFont.font(size: 30))
                .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.primary))
                
            HStack {
                Text(entity.channelName)
                Text("|")
                Text(entity.time)
                
                Spacer()
            }
            .font(.WantedFont.midFont.font(size: 16))
        }
        .padding(.horizontal, 10)
    }
}

#if DEBUG
#Preview {
    HomeView()
}
#endif
