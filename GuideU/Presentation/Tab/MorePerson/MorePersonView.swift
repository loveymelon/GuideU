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
        ZStack(alignment: .top) {
            // 배경 이미지가 네비게이션 바까지 침범하도록 ZStack에 위치
            backgroundImage(size: CGSize(width: UIScreen.main.bounds.width, height: 270 + -offsetY), minY: offsetY)
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
                .sheet(item: $store.selectedURL.sending(\.bindingURL)) { socialURL in
                    WKWebHosting(url: socialURL)
                }
                .onAppear {
                    store.send(.viewCycleType(.onAppear))
                }
                .onChange(of: store.currentMoreType) { newValue in
                    withAnimation {
                        moreType = newValue
                    }
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
                        switch moreType {
                        case .characters:
                            
                            characterSectionView()
                            
                        case .memes:
                    
                            memeSectionView()
                                .padding(.vertical, 5)
                            
                        }
                    }
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
    
    @ViewBuilder
    private func characterSectionView() -> some View {
        if !store.charactersInfo.isEmpty {
            ForEach(store.charactersInfo, id: \.id) { model in
                PersonSectionView(selectedURL: { urlString in
                    store.send(.viewEventType(.socialTapped(urlString)))
                }, setModel: model)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.all, 10)
                .shadow(radius: 4)
            }
        } else {
            Color.white
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(.white)
        }
    }
    
    private func memeSectionView() -> some View {
        VStack {
            if !store.bookElementsInfo.isEmpty {
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
extension URL: Identifiable {
    public var id: UUID {
        return UUID()
    }
}

//#if DEBUG
//#Preview {
//    MorePersonView(store: Store(initialState: PersonFeature.State(), reducer: {
//        PersonFeature()
//    }))
//}
//#endif
