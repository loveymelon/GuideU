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
    @State private var moreType: PersonFeature.MoreType = .characters
    @Namespace var name
    
    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .top) {
                // 배경 이미지가 네비게이션 바까지 침범하도록 ZStack에 위치
                backgroundImage(size: CGSize(
                    width: UIScreen.main.bounds.width,
                    height: 270 + -offsetY )
                )
                    .ignoresSafeArea(edges: .top) // Safe area까지 무시
                
                
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
                .onChange(of: store.currentMoreType) { newValue in
                    moreType = newValue
                }
                
            }
            .sheet(item: $store.selectedURL.sending(\.bindingURL)) { socialURL in
                WKWebHosting(url: socialURL.url)
                    .onAppear {
                        print ( socialURL )
                    }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    private func mainView() -> some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                headerView()
                    .frame(height: 150)
                    .background(Color.clear)
                
                LazyVStack(spacing: 0) {
                    Color.clear.frame(height: 10)
                    VStack {
                        switch moreType {
                        case .characters:
                            characterSectionView()
                        case .memes:
                            memeSectionView()
                                .padding(.vertical, 5)
                        }
                    }
                }
                .background(.white)
                
                Color.white
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.white)
            }
            .background {
                ScrollDetector { offset in
                    DispatchQueue.main.async {
                        offsetY = offset + 80
                        opacity = max(0, min(1, 1 - (offsetY / 100)))
                        print("투명도 : ",opacity)
                    }
                } onDraggingEnd: { offset, veloc in
                    
                }
            }
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
    
    
    private func characterSectionView() -> some View {
        ForEach(store.charactersInfo, id: \.id) { model in
            PersonSectionView(selectedURL: { urlString in
                store.send(.viewEventType(.socialTapped(urlString)))
            }, setModel: model)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.all, 10)
            .shadow(radius: 4)
        }
    }
    
    private func memeSectionView() -> some View {
        ForEach(store.bookElementsInfo, id: \.id) { model in
            Section {
                LazyVStack {
                    ForEach(model.memes, id: \.id) { model in
                        MemeExtendView(selectedURL: { urlString in
                            store.send(.viewEventType(.socialTapped(urlString)))
                        }, setModel: model)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.all, 10)
                        .shadow(radius: 4)
                    }
                }
                .padding(.bottom, 10)
            } header: {
                HStack {
                    Image.clock
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 25)
                    
                    Text(model.timestamp)
                        .font(Font(WantedFont.midFont.font(size: 15)))
                    Spacer()
                }
                .padding(.horizontal, 10)
            }
        }
    }
    
    private func fakeNavigation(entity: HeaderEntity, opacity: CGFloat) -> some View {
        ZStack {
            HStack {
                Image.backBlack
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 25)
                    .asButton {
                        /// 뒤로가기 달아야함
                    }
                Spacer()
            }
            Text("왁타버스 알아보기")
                .font(Font(WantedFont.boldFont.font(size: 21)))
                .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.gray1))
                .frame(maxWidth: .infinity)
                .opacity(1 - opacity)
            
            Text(entity.title)
                .font(Font(WantedFont.boldFont.font(size: 23)))
                .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.gray1))
                .frame(maxWidth: .infinity)
                .opacity(opacity)
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
            ForEach(PersonFeature.MoreType.allCases, id: \.self) { caseOf in
                
                VStack {
                    Text(caseOf.text)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(caseOf == store.currentMoreType ? Font(WantedFont.boldFont.font(size: fontSize)) : Font(WantedFont.midFont.font(size: fontSize)))
                        .asButton {
                            store.send(.viewEventType(.switchCurrentType(caseOf)))
                        }
                    Group {
                        if caseOf == moreType {
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
    
    private func backgroundImage(size: CGSize) -> some View {
        let safeHeight = size.height < 0 ? 0 : size.height
        return Group {
            /// 조건에 따라 이미지 변경할것.
            Image.defaultBack.resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: safeHeight)
                .clipped()
        }
        .blur(radius: 40, opaque: true)
        .opacity(0.2)
    }
}

//#if DEBUG
//#Preview {
//    MorePersonView(store: Store(initialState: PersonFeature.State(), reducer: {
//        PersonFeature()
//    }))
//}
//#endif
