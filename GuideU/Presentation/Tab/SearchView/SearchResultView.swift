//
//  SearchResultView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/13/24.
//

import SwiftUI
import ComposableArchitecture

struct SearchResultView: View {
    
    @Perception.Bindable var store: StoreOf<SearchResultFeature>
    
    @EnvironmentObject var colorSystem: ColorSystem
    @Environment(\.openURLManager) var openURLManager
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    contentView()
                        .background(colorSystem.color(colorCase: .background))
                        .padding(.top, 10)
                }
            }
            .background(colorSystem.color(colorCase: .background))
            .onChange(of: store.openURLCase) { newValue in
                guard let openURL = newValue else { return }
                print("change")
                
                store.send(.viewEventType(.successOpenURL))
                Task {
                   await openURLManager.openAppUrl(urlCase: openURL)
                }
            }
            .onAppear {
                store.send(.viewCycleType(.viewOnAppear))
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(.backBlack)
                        .renderingMode(.template)
                        .foregroundStyle(colorSystem.color(colorCase: .textColor))
                        .asButton {
                            store.send(.viewEventType(.backButtonTapped))
                        }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(Const.navTitle)
                        .font(Font(WantedFont.semiFont.font(size: 20)))
                        .frame(height: 52)
                        .foregroundStyle(colorSystem.color(colorCase: .textColor))
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension SearchResultView {
    
    @ViewBuilder
    private func contentView() -> some View {
        switch store.currentViewState {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(colorSystem.color(colorCase: .background))
        case .success:
            memeView()
        case .failure:
            errorView()
        }
    }
    
    private func memeView() -> some View {
        VStack {
            titleSection(model: store.searchResultEntity)
                .padding(.horizontal, 8)
            if store.meanIsvalid, let mean = store.searchResultEntity.mean {
                meanSection(mean: mean)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
            }
            if store.desIsvalid {
                descriptionSection(description: store.searchResultEntity.description)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
            }
            
            if store.meanIsvalid || store.desIsvalid {
                Divider()
                    .frame(height: 1)
                    .overlay(colorSystem.color(colorCase: .lineColor))
                    .padding(.horizontal, 16)
            }
            
            if store.videoIsvalid {
                relatedSection(related: store.searchResultEntity.relatedVideos, links: store.searchResultEntity.links)
                    .padding(.horizontal, 16)
            }
            
            if !store.meanIsvalid && !store.desIsvalid && !store.videoIsvalid {
                errorView()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func titleSection(model: SearchResultEntity) -> some View {
        VStack {
            HStack {
                MarqueeTextView(text: model.name, font: WantedFont.semiFont.font(size: 24), leading: 10, trailing: 10, startDelay: 1, alignment: .leading)
                    .environmentObject(colorSystem)
                    .padding(.horizontal, 4)
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                
                caseOfView(model: model)
                Spacer()
            }
            .padding(.bottom, 8)
            Divider()
                .frame(height: 1)
                .overlay(colorSystem.color(colorCase: .lineColor))
                .padding(.horizontal, 8)
        }
    }
    
    
    private func meanSection(mean: String) -> some View {
        VStack(spacing: 10) {
            HStack {
                Text(store.meanText)
                    .font(Font(WantedFont.semiFont.font(size: 22)))
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                Spacer()
            }
            HStack {
                
                Text(mean)
                    .font(Font(WantedFont.midFont.font(size: 16)))
                    .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
                
                Spacer()
            }
        }
    }
    
    private func descriptionSection(description: String) -> some View {
        VStack(spacing: 10) {
            HStack {
                Text(store.descriptionText)
                    .font(Font(WantedFont.semiFont.font(size: 22)))
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                Spacer()
            }
            HStack {
                Text(description)
                    .font(Font(WantedFont.regularFont.font(size: 16)))
                    .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func relatedSection(related: [RelatedVideoEntity], links: [LinkEntity]) -> some View {
        
        if store.searchResultEntity.resultType == .character {
            let rows: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
            VStack {
                HStack {
                    Text(Const.relatedURL)
                        .font(Font(WantedFont.semiFont.font(size: 22)))
                        .foregroundStyle(colorSystem.color(colorCase: .textColor))
                    Spacer()
                }
                .padding(.top, 8)
                LazyVGrid(columns: rows) {
                    ForEach(links, id: \.self) { item in
                        socialElementView(item: item)
                    }
                }
                .padding(.bottom, 4)
            }
        } else {
            VStack {
                HStack {
                    Text(Const.related)
                        .font(Font(WantedFont.semiFont.font(size: 22)))
                        .foregroundStyle(colorSystem.color(colorCase: .textColor))
                    Spacer()
                }
                .padding(.top, 8)
                LazyVStack {
                    ForEach(related, id: \.link) { model in
                        SearchResultRelatedView(setModel: model)
                            .environmentObject(colorSystem)
                            .asButton {
                                store.send(.viewEventType(.selectedRelatedModel(model)))
                            }
                            .padding(.bottom, 8)
                    }
                }
            }
        }
    }
    
    private func errorView() -> some View {
        VStack {
            Image("NoData")
                .resizable()
                .frame(width: 266, height: 266)
                .padding(.bottom, 20)
            
            Text(Const.ErrorDes.searchNoData.title)
                .font(Font(WantedFont.boldFont.font(size: 24)))
                .foregroundStyle(colorSystem.color(colorCase: .textColor))
                .padding(.bottom, 8)
            
            Text(Const.ErrorDes.searchNoData.des)
                .font(Font(WantedFont.midFont.font(size: 16)))
                .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorSystem.color(colorCase: .background))
    }
    
    private func socialElementView(item: LinkEntity) -> some View {
        VStack {
            switch item.type {
            case .afreeca:
                HStack {
                    Image.SocialImages.soop.img
                    Text(Const.soopSection)
                        .padding(.leading, 8)
                    Spacer()
                }
            case .instagram:
                HStack {
                    Image.SocialImages.instagram.img
                    Text(Const.instagramSection)
                        .padding(.leading, 8)
                    Spacer()
                }
            case .twitter:
                HStack {
                    Image.SocialImages.twitterX.img
                    Text(Const.xTwitterSection)
                        .padding(.leading, 8)
                    Spacer()
                }
            case .youtube:
                HStack {
                    Image.SocialImages.youtube.img
                    Text(Const.youtubeSection)
                        .padding(.leading, 8)
                    Spacer()
                }
            default :
                EmptyView()
            }
        }
        .font(Font(WantedFont.midFont.font(size: 17)))
        .foregroundStyle(colorSystem.color(colorCase: .textColor))
        .padding(.horizontal, 10)
        .asButton {
            store.send(.viewEventType(.socialTapped(item.link)))
        }
        .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.textColor))
    }
}

extension SearchResultView {
    
    private func caseOfView(model: SearchResultEntity) -> some View {
        Text(model.resultType.title)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background {
                switch model.resultType {
                case .character:
                    Color(GuideUColor.ViewBaseColor.light.pinkType)
                case .meme:
                    Color(GuideUColor.ViewBaseColor.light.greenType)
                }
            }
            .foregroundStyle(colorSet(model: model))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .font(Font(WantedFont.regularFont.font(size: 15)))
    }
    
    private func colorSet(model: SearchResultEntity) -> Color {
        switch model.resultType {
        case .character:
            return Color(GuideUColor.ViewBaseColor.light.darkPinkType)
        case .meme:
            return Color(GuideUColor.ViewBaseColor.light.darkGreenType)
        }
    }
}

#if DEBUG
//#Preview {
//    SearchResultView(store: Store(initialState: SearchResultFeature.State(currentSearchKeyword: "우왁굳"), reducer: {
//        SearchResultFeature()
//    }))
//}
#endif
