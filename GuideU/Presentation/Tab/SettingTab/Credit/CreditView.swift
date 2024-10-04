//
//  CreditView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/4/24.
//

import SwiftUI
import ComposableArchitecture

struct CreditView: View {
    
    @Perception.Bindable var store: StoreOf<CreditViewFeature>
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        VStack {
            Color.clear.frame(height: 4) // 약간의 여백
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
    
    private func contentView() -> some View {
        List {
            ForEach(store.creditCase, id: \.self) { credit in
                VStack {
                    Text(credit.title)
                        .font(Font(WantedFont.semiFont.font(size: 20)))
                        .foregroundStyle(colorSystem.color(colorCase: .detailGrayColor))
                        .padding(.vertical, 12)
                }
                .asButton {
                    store.send(.viewEvent(.selectedCase(credit)))
                }
                .listRowBackground(colorSystem.color(colorCase: .background))
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollDisabled(true)
        .background(colorSystem.color(colorCase: .background))
    }
}
