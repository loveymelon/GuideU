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
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    var body: some View {
        WithPerceptionTracking {
            
            switch store.viewState {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(colorSystem.color(colorCase: .background))
            case .success:
                VStack {
                    contentView()
                        .padding(.horizontal, 10)
                }
                .background(colorSystem.color(colorCase: .background))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(Const.recentFind)
                            .font(Font(WantedFont.semiFont.font(size: 20)))
                            .foregroundStyle(colorSystem.color(colorCase: .textColor))
                    }
                }
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
                        .onChange(of: store.openURLCase) { newValue in
                            guard let openURL = newValue else { return }
                            
                            store.send(.viewEventType(.successOpenURL))
                            Task {
                                await openURLManager.openAppUrl(urlCase: openURL)
                            }
                        }
                        .onDisappear {
                            store.send(.viewCycleType(.viewDisAppear))
                        }
                    }
                }
            case .failure:
                errorView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(colorSystem.color(colorCase: .background))
            }
        }
    }
}

extension HistoryView {
    
    private func contentView() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                Color.clear.frame(height: 0)
                    .id(store.scrollID)
                ForEach(store.videosEntity, id: \.lastWatched) { section in
                    HStack {
                        Text(section.lastWatched)
                            .font(Font(WantedFont.midFont.font(size: 16)))
                            .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 14)
                    
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
            .onChange(of: store.scrollToTopTrigger) { newValue in
                withAnimation {
                    proxy.scrollTo(store.scrollID)
                }
            }
        }
    }
    
    private func errorView() -> some View {
        VStack {
            Image(ImageType.ErrorImage.lightNoData.rawValue)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding(.bottom, 30)
                .padding(.top, 40)
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

