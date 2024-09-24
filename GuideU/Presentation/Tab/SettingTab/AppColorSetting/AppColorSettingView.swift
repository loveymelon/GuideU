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
    
    var body: some View {
        WithPerceptionTracking {
            contentView()
                .background(colorSystem.color(colorCase: .background))
        }
    }
    
}

extension AppColorSettingView {
    private func contentView() -> some View {
        VStack {
            List {
                ForEach(CurrentColorModeCase.allCases, id: \.self) { caseOf in
                    Button {
                        store.send(.viewEvent(.selectedCase(caseOf)))
                    } label: {
                        Text(caseOf.title)
                    }
                }
            }
        }
    }
}
