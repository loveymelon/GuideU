//
//  AppColorSettingView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/24/24.
//

import SwiftUI
import ComposableArchitecture

struct AppColorSettingView: View {
    
    @Perception.Bindable var store: StoreOf<AppColorSettingFeature>
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    private let gridItems: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        WithPerceptionTracking {
            contentView()
                .background(colorSystem.color(colorCase: .background))
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Image(.backBlack)
                            .renderingMode(.template)
                            .foregroundStyle(colorSystem.color(colorCase: .textColor))
                            .asButton {
                                store.send(.viewEvent(.backButtonTapped))
                            }
                    }
                }
                .navigationTitle(Const.theme)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
        }
    }
    
}

extension AppColorSettingView {
    private func contentView() -> some View {
        VStack(alignment: .center) {
            HStack(alignment: .top) {
                ForEach(CurrentColorModeCase.allCases, id: \.self) { caseOf in
                    caseContentView(caseOf)
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
            Spacer()
        }
    }
}

extension AppColorSettingView {
    
    private func caseContentView(_ caseOf: CurrentColorModeCase) -> some View {
        VStack(spacing: 8) {
            caseImage(caseOf)
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .overlay {
                    if store.currentCase == caseOf {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colorSystem.color(colorCase: .pointColor), lineWidth: 2)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(colorSystem.color(colorCase: .textColor), lineWidth: 0.8)
                    }
                    
                }
                .asButton {
                    store.send(.viewEvent(.selectedCase(caseOf)))
                }
            
            Text(caseOf.title)
                .font(Font(WantedFont.boldFont.font(size: 16)))
                .foregroundStyle(colorSystem.color(colorCase: .textColor))
                .padding(.top, 5)
            
            if caseOf == .system {
                Text("현재 시스템 컬러는\n\(colorSystem.currentColor()) 입니다.")
                    .font(Font(WantedFont.regularFont.font(size: 12)))
                    .foregroundStyle(colorSystem.color(colorCase: .subGrayColor))
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private func caseImage(_ caseOf: CurrentColorModeCase) -> some View {
        switch caseOf {
        case .dark:
            Image(.guiduDark)
                .resizable()
        case .light:
            Image(.guiduLight)
                .resizable()
        case .system:
            if colorSystem.currentColorScheme == .light {
                Image(.guiduLight)
                    .resizable()
            } else {
                Image(.guiduDark)
                    .resizable()
            }
        }
    }
}
