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
    @State private var titleOffset = UIScreen.main.bounds.width
    @Namespace var name
    
    @Environment(\.openURLManager) var openURLManager
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                switch store.videoState {
                case .loading:
                    VStack {
                        Spacer()
                        
                        LottieEntry(setAnimation: .loading, setLoopMode: .autoReverse)
                            .frame(maxWidth: .infinity)
                            .background(colorSystem.color(colorCase: .background))
                            .navigationBarBackButtonHidden()
                            .onAppear {
                                store.send(.viewCycleType(.onAppear))
                            }

                        
                        Spacer()
                    }
                    .background(colorSystem.color(colorCase: .background))
                case .content:
                    ZStack(alignment: .top) {
                        // 배경 이미지가 네비게이션 바까지 침범하도록 ZStack에 위치
                        backgroundImage(size: CGSize(
                            width: UIScreen.main.bounds.width,
                            height: 275 + -offsetY )
                        )
                        .ignoresSafeArea(edges: .top) // Safe area까지 무시
                        
                        ZStack(alignment: .bottom) {
                            VStack(spacing: 0) {
                                mainView()
                                    .safeAreaInset(edge: .top) {
                                        // 네비게이션 바를 고정시킴
                                        fakeNavigation(entity: store.headerState, opacity: 1 - opacity)
                                            .frame(maxWidth: .infinity)
                                    }
                            }
                            .onChange(of: store.currentMoreType) { newValue in
                                withAnimation {
                                    moreType = newValue
                                }
                            }
                            Text(Const.moreCheckText)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 14)
                                .font(Font(WantedFont.semiFont.font(size: 20)))
                                .background(colorSystem.color(colorCase: .pointColor))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .asButton {
                                    store.send(.viewEventType(.moreButtonTapped))
                                }
                                .foregroundStyle(Color(GuideUColor.ViewBaseColor.dark.textColor))
                                .padding(.horizontal, 10)
                                .padding(.bottom, 10)
                        }
                    }
                    .background(colorSystem.color(colorCase: .background))
                    .onChange(of: store.openURLCase) { newValue in
                        guard let openURL = newValue else { return }
                        
                        store.send(.viewEventType(.successOpenURL))
                        Task {
                            await openURLManager.openAppUrl(urlCase: openURL)
                        }
                    }
                    .toolbar(.hidden, for: .navigationBar)
                case .severError:
                    errorView(imageType: .noData, errorType: .serverError)
                        .background(colorSystem.color(colorCase: .background))
                case .none:
                    errorView(imageType: .notWak, errorType: .noWak)
                        .navigationBarBackButtonHidden()
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Image(.backBlack)
                                    .renderingMode(.template)
                                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                                    .asButton {
                                        store.send(.viewEventType(.backButtonTapped))
                                    }
                            }
                        }
                        .background(colorSystem.color(colorCase: .background))

                }
            }
            .background(colorSystem.color(colorCase: .background))
        }
    }
    
    private func errorView(imageType: ImageType.ErrorImage, errorType: Const.ErrorDes) -> some View {
        VStack(spacing: 0) {
            Image(imageType.rawValue)
                .resizable()
                .scaledToFit()
//                .frame(width: imageType == .notWak ? 260 : 249, height: imageType == .notWak ? 260 : 164)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                .padding(.top, 40)
            
            Text(errorType.title)
                .font(Font(WantedFont.boldFont.font(size: 20)))
                .foregroundStyle(colorSystem.color(colorCase: .textColor))
                .padding(.bottom, 8)
            Text(errorType.des)
                .font(Font(WantedFont.semiFont.font(size: 14)))
                .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(colorSystem.color(colorCase: .background))
    }
    
    private func mainView() -> some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                headerView()
                    .frame(height: 164)
                    .background(Color.clear)
                
                LazyVStack(spacing: 0) {
                    colorSystem.color(colorCase: .background)
                        .frame(height: 15)
                    VStack {
                        switch moreType {
                        case .characters:
                            switch store.characterState {
                            case .loading:
                                ProgressView()
                                    .background(colorSystem.color(colorCase: .background))
                            case .content:
                                characterSectionView()
                                colorSystem.color(colorCase: .background)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 80)
                            case .severError:
                                errorView(imageType: .notWak, errorType: .serverError)
                                    .background(colorSystem.color(colorCase: .background))
                            case .none:
                                errorView(imageType: .noData, errorType: .noData)
                                    .background(colorSystem.color(colorCase: .background))
                            }

                        case .memes:
                            switch store.memeState {
                            case .loading:
                                ProgressView()
                                    .background(colorSystem.color(colorCase: .background))
                            case .content:
                                memeSectionView()
                                colorSystem.color(colorCase: .background)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 80)
                            case .severError:
                                errorView(imageType: .notWak, errorType: .serverError)
                                    .background(colorSystem.color(colorCase: .background))
                            case .none:
                                errorView(imageType: .noData, errorType: .noData)
                                    .background(colorSystem.color(colorCase: .background))
                            }
                        }
                    }
                }
                .background(colorSystem.color(colorCase: .background))
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
            .background(colorSystem.color(colorCase: .cellBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .shadow(radius: 4)
            .environmentObject(colorSystem)
        }
    }
    
    
    private func memeSectionView() -> some View {
        ForEach(store.bookElementsInfo, id: \.id) { model in
            HStack {
                Image(ImageType.OtherImage.clock.rawValue)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 25)
                
                Text(model.timestamp)
                    .font(Font(WantedFont.midFont.font(size: 15)))
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.top, 5)
            
            VStack {
                ForEach(model.memes, id: \.id) { model in
                    MemeExtendView(selectedURL: { urlString in
                        store.send(.viewEventType(.socialTapped(urlString)))
                    }, setModel: model)
                    .background(colorSystem.color(colorCase: .cellBackground))
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .shadow(radius: 4)
                    .environmentObject(colorSystem)
                }
            }
            .padding(.bottom, 10)

        }
        .background(colorSystem.color(colorCase: .background))
    }
    
    private func fakeNavigation(entity: HeaderEntity, opacity: CGFloat) -> some View {
        ZStack {
            HStack {
                Image(ImageType.ButtonImage.backButton.rawValue)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                    .frame(height: 25)
                    .padding(.leading, 10)
                    .asButton {
                        store.send(.viewEventType(.backButtonTapped))
                    }
                Spacer()
            }
            Text(Const.moreInfoText)
                .font(Font(WantedFont.boldFont.font(size: 21)))
                .foregroundStyle(colorSystem.color(colorCase: .textColor))
                .frame(maxWidth: .infinity)
                .opacity(1 - opacity)
            
            Text(entity.title)
                .font(Font(WantedFont.boldFont.font(size: 23)))
                .foregroundStyle(colorSystem.color(colorCase: .textColor))
                .frame(maxWidth: .infinity)
                .opacity(opacity)
                .padding(.horizontal, 80)
        }
        .frame(height: 50)
        .background(colorSystem.color(colorCase: .background).opacity(opacity))
    }
    
    private func headerContentView(entity: HeaderEntity) -> some View {
        VStack(alignment: .leading) {
            Text(entity.sectionTitle)
                .font(Font(WantedFont.midFont.font(size: 16)))
                .foregroundStyle(colorSystem.color(colorCase: .textColor))
                .padding(.bottom, 4)
            
            MarqueeTextView(
                text: entity.title,
                font: WantedFont.boldFont.font(size: 28),
                leading: 2,
                trailing: 15,
                startDelay: 1
            )
            .foregroundStyle(colorSystem.color(colorCase: .pointColor))
            .padding(.bottom, 6)
            
            HStack {
                Text(entity.channelName)
                Text("|")
                Text(entity.time)
                
                Spacer()
            }
            .font(Font(WantedFont.midFont.font(size: 14)))
            .foregroundStyle(colorSystem.color(colorCase: .textColor))
            .padding(.bottom, 10)
            
            switchView()
        }
        .padding(.horizontal, 10)
    }
    
    private func switchView() -> some View {
        let fontSize: CGFloat = 15
        
        return HStack(spacing: 0) {
            ForEach(PersonFeature.MoreType.allCases, id: \.self) { caseOf in
                VStack(spacing: 0) {
                    
                    Text(caseOf.text)
                        .foregroundStyle(colorSystem.color(colorCase: .textColor))
                        .frame(maxWidth: .infinity)
                        .font(caseOf == store.currentMoreType ? Font(WantedFont.boldFont.font(size: fontSize)) : Font(WantedFont.midFont.font(size: fontSize)))
                        .padding(.top, 10)
                        .padding(.bottom, 6)
                        .asButton {
                            store.send(.viewEventType(.switchCurrentType(caseOf)))
                        }
                    
                    Group {
                        if caseOf == moreType {
                            Capsule()
                                .foregroundColor(colorSystem.color(colorCase: .pointColor))
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
    }
    
    private func backgroundImage(size: CGSize) -> some View {
        let safeHeight = size.height < 0 ? 0 : size.height + 20
        return Group {
            /// 조건에 따라 이미지 변경할것
            if let url = store.headerState.thumImage {
                DownImageView(url: url, option: .mid)
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(ImageType.backImage.defaultBack.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .transition(.opacity)
        .frame(width: size.width, height: safeHeight)
        .blur(radius: 20, opaque: false)
        .clipped()
        .opacity(0.22)
        
    }
}

#if DEBUG
#Preview {
    MorePersonView(store: Store(initialState: PersonFeature.State( identifierURL: "HDHOeLYT0rE"), reducer: {
        PersonFeature()
    }))
}
#endif
