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
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                contentView()
            }
            .onAppear {
                store.send(.viewCycleType(.viewOnAppear))
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(.backBlack)
                        .asButton {
                            store.send(.viewEventType(.backButtonTapped))
                        }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

extension SearchResultView {
    
    @ViewBuilder
    private func contentView() -> some View {
        if let model = store.searchResultEntity {
            VStack {
                titleSection(model: model)
                    .padding(.horizontal, 8)
                if let mean = model.mean {
                    meanSection(mean: mean)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                }
                if !model.description.isEmpty {
                    descriptionSection(description: model.description)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                }
                
                Divider()
                    .frame(height: 1)
                    .overlay(colorSystem.color(colorCase: .lineColor))
                    .padding(.horizontal, 16)
                relatedSection(related: model.relatedVideos)
            }
        } else {
            EmptyView()
        }
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
    
    private func relatedSection(related: [RelatedVideoEntity]) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(related, id: \.link) { model in
                    SearchResultRelatedView(setModel: model)
                        .environmentObject(colorSystem)
                }
            }
        }
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
#Preview {
    SearchResultView(store: Store(initialState: SearchResultFeature.State(currentSearchKeyword: "우왁굳"), reducer: {
        SearchResultFeature()
    }))
}
#endif
