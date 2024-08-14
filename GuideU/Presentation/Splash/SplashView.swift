//
//  SplashView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/12/24.
//

import SwiftUI
import ComposableArchitecture

struct SplashView: View {
    
    @Perception.Bindable var store: StoreOf<SplashFeature>
    
    var body: some View {
        WithPerceptionTracking {
            contentView()
                .onAppear {
                    store.send(.onAppear)
                }
        }
    }
}

extension SplashView {
    private func contentView() -> some View {
        ZStack(alignment: .topLeading) {
            Image(.splash1)
                .resizable()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(alignment: .leading, spacing: 24 ) {
                Group {
                    Image(.appLogo)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 55, height: 55)
                    
                    Text(Const.Splash.splashText)
                        .font(.WantedFont.boldFont.font(size: 34))
                        .foregroundStyle(.white)
                }
                .padding(.leading, 20)
            }
        }
    }
}

#if DEBUG
#Preview {
    SplashView(store: Store(initialState: SplashFeature.State(), reducer: {
        SplashFeature()
    }))
}
#endif
