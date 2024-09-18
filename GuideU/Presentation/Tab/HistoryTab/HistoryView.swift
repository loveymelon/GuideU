//
//  HistoryView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/13/24.
//

import SwiftUI
import ComposableArchitecture


struct HistoryView: View {
    
    @Perception.Bindable var store: StoreOf<HistoryFeature>
    
    @Environment(\.openURLManager) var openURLManager
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                ForEach(store.videosEntity, id: \.lastWatched) { section in
                    HStack {
                        Text(section.lastWatched)
                            .font(Font(WantedFont.midFont.font(size: 16)))
                            .foregroundStyle(Color(GuideUColor.ViewBaseColor.light.gray2))
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    LazyVStack {
                        ForEach(section.videosEntity, id: \.id) { element in
                            MoreCharacterListView(setModel: element)
                                .padding(.bottom, 8)
                                .asButton {
                                    store.send(.viewEventType(.videoTapped(element)))
                                }
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("최근 알아본")
            .confirmationDialog(MoreCharacterDialog.title, isPresented: $store.dialogPresent.sending(\.dialogBinding), titleVisibility: .visible) {
                Group {
                    ForEach(MoreCharacterDialog.allCases, id: \.self) { caseOf in
                        switch caseOf {
                        case .buttonTitle1:
                            Button(caseOf.buttonTitle) {
                                store.send(.viewEventType(.youtubeButtonTapped))
                            }
                        case .buttonTitle2:
                            Button(caseOf.buttonTitle) {
                                store.send(.viewEventType(.detailButtonTapped))
                            }
                        }
                    }
                }
            }
            .onChange(of: store.openURLCase) { newValue in
                guard let openURL = newValue else { return }
        
                store.send(.viewEventType(.successOpenURL))
                openURLManager.openAppUrl(urlCase: openURL)
            }
            .onAppear {
                store.send(.viewCycleType(.viewOnAppear))
            }
            .onDisappear {
                store.send(.viewCycleType(.viewDisAppear))
            }
            
        }
    }
}

#if DEBUG
#Preview {
    HistoryView(store:  Store(initialState: HistoryFeature.State(), reducer: {
        HistoryFeature()
    }))
}
#endif

