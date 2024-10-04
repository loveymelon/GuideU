//
//  FirstMeritView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/4/24.
//

import SwiftUI
import ComposableArchitecture

struct FirstMeritView: View {
    
    @Perception.Bindable var store: StoreOf<FirstMeritViewFeature>
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        VStack {
            contentView()
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(.backBlack)
                    .renderingMode(.template)
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
                    .asButton {
                        store.send(.viewEvent(.backButtonTapped))
                    }
            }
            
            ToolbarItem(placement: .principal) {
                Text(store.navTitle)
                    .font(Font(WantedFont.semiFont.font(size: 20)))
                    .frame(height: 52)
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
            }
        }
        .background(colorSystem.color(colorCase: .background))
    }
}

extension FirstMeritView {
    private func contentView() -> some View {
        ScrollView {
            Color.clear
                .frame(height: 10)
            
            ForEach(store.teamRole, id: \.self) { caseOf in
                VStack(spacing: 6) {
                    
                    Text(caseOf.title)
                        .font(Font(WantedFont.midFont.font(size:16)))
                        .foregroundStyle(colorSystem.color(colorCase: .pointColor))
                    
                    Text(
                        caseOf.member.styledText(
                            fullFont: WantedFont.semiFont.font(size: 20),
                            fullColor: UIColor(
                                colorSystem.color(
                                    colorCase: .textColor
                                )
                            ),
                            targetTexts: store.targetTexts,
                            targetFont:  WantedFont.semiFont.font(size: 20),
                            targetColor: UIColor(
                                colorSystem.color(
                                    colorCase: .subTextColor
                                )
                            )
                        )
                    )
                    .lineSpacing(3)
                }
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .background(colorSystem.color(colorCase: .background))
                .padding(.vertical, caseOf.paddingOptions ? 2 : 10 )
            }
        }
        .background(colorSystem.color(colorCase: .background))
    }
}
