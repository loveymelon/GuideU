//
//  AppInfoView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/20/24.
//

import SwiftUI
import ComposableArchitecture

struct AppInfoView: View {
    
    @Perception.Bindable var store: StoreOf<AppInfoFeature>
    
    @EnvironmentObject var colorSystem: ColorSystem
     
    var body: some View {
        WithPerceptionTracking {
            contentView()
                .padding(.top, 20)
                .padding(.horizontal, 16)
                .navigationTitle(store.navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .background(colorSystem.color(colorCase: .background))
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Image(.backBlack)
                            .renderingMode(.template)
                            .foregroundStyle(colorSystem.color(colorCase: .textColor))
                            .asButton {
                                store.send(.didTapBackButton)
                            }
                    }
                }
        }
    }
}

extension AppInfoView {
    private func contentView() -> some View {
        VStack(spacing: 14) {
            HStack {
                Text(store.sectionTitle)
                    .font(Font(WantedFont.midFont.font(size: 16)))
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                Spacer()
            }
            
            HStack(spacing: 14) {
                Image(store.appLogoImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 60)
                    .shadow(radius: 1)
                
                VStack(spacing: 5) {
                    HStack {
                        Text(store.appName)
                            .font(Font(WantedFont.semiFont.font(size: 20)))
                            .foregroundStyle(colorSystem.color(colorCase: .textColor))
                        Spacer()
                    }
                    HStack {
                        Text(store.appVersion)
                            .font(Font(WantedFont.midFont.font(size: 14)))
                            .foregroundStyle(colorSystem.color(colorCase: .subGrayColor))
                        Spacer()
                    }
                }
            }
            
            Spacer()
        }
    }
}

#if DEBUG
#Preview {
    AppInfoView(store: Store(initialState: AppInfoFeature.State(), reducer: {
        AppInfoFeature()
    }))
}
#endif
