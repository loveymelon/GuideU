//
//  OnBoardPageView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import SwiftUI
import ComposableArchitecture

struct OnBoardPageView: View {
    
    @Perception.Bindable var store: StoreOf<OnboardPageFeature>
    
    @State var currentImage: ImageType.OnBoardingImage = .first
    @State var currentButtonState = false
    
    var body: some View {
        WithPerceptionTracking {
            contentView()
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

extension OnBoardPageView {
    private func contentView() -> some View {
        ZStack(alignment: .bottom) {
            pageView()
            startButton()
                .padding(.bottom, 50)
        }
    }
    
    private func pageView() -> some View {
        TabView(selection: $currentImage) {
            ForEach(ImageType.OnBoardingImage.allCases, id: \.self) { caseOf in
                Image(caseOf.rawValue)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(edges: .bottom)
                    .tag(caseOf)
            }
        }
        .tabViewStyle(.page)
        .onChange(of: currentImage) { newValue in
            if currentImage == .fore {
                withAnimation {
                    currentButtonState = true
                }
            }
        }
    }
    
    @ViewBuilder
    private func startButton() -> some View {
        if currentButtonState {
            Text("시작하기")
                .font(Font(WantedFont.midFont.font(size: 18)))
                .padding(.all, 8)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .asButton {
                    store.send(.startButtonTapped)
                }
                .foregroundStyle(.black)
        } else {
            EmptyView()
        }
    }
}
