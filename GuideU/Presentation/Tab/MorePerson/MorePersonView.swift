//
//  MorePersonView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/9/24.
//

import SwiftUI
import ComposableArchitecture

struct MorePersonView: View {
    
    @State private var offsetY: CGFloat = 0
    @Perception.Bindable var store: StoreOf<PersonFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                GeometryReader {
                    let safeArea = $0.safeAreaInsets
                    mainView(safeArea: safeArea)
                    .ignoresSafeArea(.all, edges: .top)
                }
            }
            .onAppear {
                store.send(.viewCycleType(.onAppear))
            }
        }
    }
    
    private func mainView(safeArea: EdgeInsets) -> some View {
        
        GeometryReader { geometry in
            WithPerceptionTracking {
                
                let size = geometry.size
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        headerView(size: size, safeArea: safeArea)
                            .zIndex(1000)
                        LazyVStack {
                            ForEach(1...100, id: \.self ) { num in
                                PersonSectionView()
                            }
                            .frame(width: size.width)
                        }
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
        }
    }
    
    @ViewBuilder
    func headerView(size: CGSize, safeArea: EdgeInsets) -> some View {
        let headerHeight = (size.height * 0.3) + safeArea.top
        let minHeight = 80 + safeArea.top
        let changeHeight = (headerHeight + offsetY)
        let opacity = 0.8 + (offsetY / 100)
        
        GeometryReader { proxy in
            WithPerceptionTracking {
                let size = proxy.size
                backgroundImage(size: size, minY: offsetY)
                    .offset(y: -offsetY)
                    .frame(height: changeHeight < minHeight ? minHeight : changeHeight, alignment: .bottom)
                
                VStack(spacing: 20) {
                    fakeNavigation(size: size, entity: store.headerState, opacity: -opacity)
                        .padding(.top, safeArea.top + 10)
                        .offset(y: -offsetY)
                        .zIndex(3000)
                    headerContentView(size: size, entity: store.headerState)
                        .opacity(opacity)
                }
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
                    .font(Font(WantedFont.boldFont.font(size: 23)))
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
                .font(Font(WantedFont.midFont.font(size: 16)))
                .padding(.bottom, 4)
            
            Text(entity.title)
                .font(Font(WantedFont.boldFont.font(size: 30)))
                .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.primary))
                
            HStack {
                Text(entity.channelName)
                Text("|")
                Text(entity.time)
                
                Spacer()
            }
            .font(Font(WantedFont.midFont.font(size: 16)))
        }
        .padding(.horizontal, 10)
    }
}

#if DEBUG
#Preview {
    MorePersonView(store: Store(initialState: PersonFeature.State(), reducer: {
        PersonFeature()
    }))
}
#endif
