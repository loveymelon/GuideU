//
//  MorePersonView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/9/24.
//

import SwiftUI
import ComposableArchitecture

struct MorePersonView: View {
    @Perception.Bindable var store: StoreOf<PersonFeature>
    
    @State private var offsetY: CGFloat = 0
    @State private var opacity: CGFloat = 1
    @Namespace var name
    
    /// Feature 로 가져가야 할 영역
    @State private var currentMoreType = moreType.characters
    
    enum moreType: CaseIterable {
        case characters
        case memes
        
        var text: String {
            switch self {
            case .characters:
                return "등장인물"
            case .memes:
                return "사용되는 밈"
            }
        }
    }
    /////////
    
    
    var body: some View {
        ZStack(alignment: .top) {
            // 배경 이미지가 네비게이션 바까지 침범하도록 ZStack에 위치
            backgroundImage(size: CGSize(width: UIScreen.main.bounds.width, height: 300 + -offsetY), minY: offsetY)
                .ignoresSafeArea(edges: .top) // Safe area까지 무시

            WithPerceptionTracking {
                VStack(spacing: 0) {
                    mainView()
                        .safeAreaInset(edge: .top) {
                            // 네비게이션 바를 고정시킴
                            fakeNavigation(entity: store.headerState, opacity: 1 - opacity)
                                .frame(maxWidth: .infinity)
                        }
                }
                .onAppear {
                    store.send(.viewCycleType(.onAppear))
                }
            }
        }
    }
    
    private func mainView() -> some View {
        WithPerceptionTracking {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    headerView()
                        .frame(height: 150)
                        .background(Color.clear)

                    LazyVStack(spacing: 0) {
                        Color.clear.frame(height: 10)
                        
                        ForEach(1...100, id: \.self ) { num in
                            PersonSectionView()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.all, 10)
                                .shadow(radius: 4)
                        }
                    }
                    .background(.white)
                }
                .background {
                    ScrollDetector { offset in
                        offsetY = offset + 80
                        opacity = max(0, min(1, 1 - (offsetY / 100)))
                        print("투명도 : ",opacity)
                    } onDraggingEnd: { offset, veloc in
                        
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            
        }
    }
    
    func headerView() -> some View {
        return ZStack(alignment: .top) {
            // 배경 이미지나 콘텐츠
            VStack {
                Spacer()
                headerContentView(entity: store.headerState)
                    .opacity(opacity)
            }
            .background(.clear)
        }
    }
    
    private func fakeNavigation(entity: HeaderEntity, opacity: CGFloat) -> some View {
        ZStack {
            HStack {
                Image.appLogo
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 42)
                    
                Text(entity.title)
                    .font(Font(WantedFont.boldFont.font(size: 23)))
                    .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.primary))
                    .frame(maxWidth: .infinity)
                    .opacity(opacity)
                
                VStack {
                    Image.search
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: 28)
                }
                .frame(width: 52)
            }
        }
        .padding(.leading, 10)
        .frame(height: 50)
        .background(.white.opacity(opacity))
    }
    
    private func headerContentView(entity: HeaderEntity) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entity.sectionTitle)
                .font(Font(WantedFont.midFont.font(size: 16)))
                .padding(.bottom, 4)
            
            Text(entity.title)
                .font(Font(WantedFont.boldFont.font(size: 28)))
                .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.primary))
                
            HStack {
                Text(entity.channelName)
                Text("|")
                Text(entity.time)
                
                Spacer()
            }
            .font(Font(WantedFont.midFont.font(size: 14)))
            .padding(.bottom, 18)
            switchView()
        }
        .padding(.horizontal, 10)
    }
    
    private func switchView() -> some View {
        let fontSize: CGFloat = 15
        
        return HStack(spacing: 0) {
            ForEach(moreType.allCases, id: \.self) { caseOf in
                VStack {
                    Text(caseOf.text)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(caseOf == currentMoreType ? Font(WantedFont.boldFont.font(size: fontSize)) : Font(WantedFont.midFont.font(size: fontSize)))
                        .asButton {
                            withAnimation {
                                currentMoreType = caseOf
                            }
                        }
                    Group {
                        if caseOf == currentMoreType {
                            Capsule()
                                .foregroundColor(Color(GuideUColor.ViewBaseColor.light.primary))
                                .matchedGeometryEffect(id: "Tab", in: name)
                        } else {
                            Capsule()
                                .foregroundColor(.clear)
                            
                        }
                    }
                    .frame(height: 3)
                    .padding(.horizontal, 10)
                }
            }
        }
        .frame(height: 30)
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
}

#if DEBUG
#Preview {
    MorePersonView(store: Store(initialState: PersonFeature.State(), reducer: {
        PersonFeature()
    }))
}
#endif
