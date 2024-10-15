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
                    ToolbarItem(placement: .principal) {
                        Text(store.navigationTitle)
                            .font(Font(WantedFont.semiFont.font(size: 20)))
                            .foregroundStyle(colorSystem.color(colorCase: .textColor))
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
        }
    }
}

extension AppInfoView {
    private func contentView() -> some View {
        ScrollView {
            appInfoSection()
                .padding(.bottom, 20)
            openSourceView()
            Spacer()
        }
    }
    
    private func appInfoSection() -> some View {
        VStack {
            HStack {
                Text(store.sectionTitle)
                    .font(Font(WantedFont.midFont.font(size: 16)))
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                Spacer()
            }
            .padding(.bottom, 6)
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
        }
    }
    
    private func openSourceView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(store.openSourceLicenseTitle)
                    .font(Font(WantedFont.midFont.font(size: 16)))
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                Spacer()
            }
            ForEach(store.appOpenSourceLicense, id: \.self) { item in
                VStack {
                    HStack {
                        Text(item.title)
                            .font(Font(WantedFont.midFont.font(size: 14)))
                            .foregroundStyle(colorSystem.color(colorCase: .textColor))
                        Spacer()
                    }
                    .padding(.bottom, 2)
                    HStack {
                        if item == .Apache || item == .MIT {
                            Text(item.subTitle)
                                .font(Font(WantedFont.midFont.font(size: 14)))
                                .foregroundStyle(colorSystem.color(colorCase: .subGrayColor))
                                .multilineTextAlignment(.center)
                        } else {
                            Text(item.subTitle)
                                .font(Font(WantedFont.midFont.font(size: 12)))
                                .foregroundStyle(colorSystem.color(colorCase: .subGrayColor))
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }
                }
                .padding(.leading, 4)
                .asButton {
                    store.send(.selectedLicense(item))
                }
                .padding(.vertical, 5)
            }
        }
    }
}

#if DEBUG
#Preview {
    let colorSystem = ColorSystem()
    AppInfoView(store: Store(initialState: AppInfoFeature.State(), reducer: {
        AppInfoFeature()
    }))
    .environmentObject(colorSystem)
}
#endif
