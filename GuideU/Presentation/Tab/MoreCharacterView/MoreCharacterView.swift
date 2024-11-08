//
//  MoreCharacterView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/28/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import PopupView

struct MoreCharacterView: View, ThreadCheckable {
    
    @Perception.Bindable var store: StoreOf<MoreCharacterFeature>
    
    @Environment(\.openURLManager) var openURLManager
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    @State private var dropdown: Bool = false
    
    private let scrollViewTopID = "ScrollTop"
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                fakeSearchBar()
                    .padding(.horizontal, 10)
                    .asButton {
                        /// View Changed
                        store.send(.viewEventType(.searchViewChanged))
                    }
                
                    .padding(.horizontal, 10)
                
                contentView()
                    .onAppear {
                        store.send(.viewCycleType(.onAppear))
                    }
                    .background(colorSystem.color(colorCase: .background))
            }
            .background(colorSystem.color(colorCase: .background))
            .errorAlert(alertModel: $store.alertMessage.sending(\.alertBinding), confirm: { item in
                store.send(.alertAction(.checkAlert(item)))
            }, cancel: { item in
                store.send(.alertAction(.cancelAlert(item)))
            })
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
                Task {
                   await openURLManager.openAppUrl(urlCase: openURL)
                }
            }
            .refreshable {
                // 새로고침 await 키워드를 통해 이를 해결
                store.send(.viewEventType(.resetData))
                
            }
        }
    }
}

extension MoreCharacterView {
    private func contentView() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                Color.clear.frame(height: 0)
                    .id(scrollViewTopID)
                ZStack(alignment: .top) {
                    ZStack {
                        if store.state.currentData.loadingTrigger {
                            skeletonView()
                        } else {
                            listContentView()
                        }
                    }
                    .background(colorSystem.color(colorCase: .background))
                    .padding(.top, 120)
                    
                    ZStack {
                        WantMoreInfoView(currentDropDownIndex: $store.dropDownIndex.sending(
                            \.dropDownIndex
                        ), dropDownOptions: store.state.dropDownOptions)
                        .environmentObject(colorSystem)
                        .padding(.top, 20)
                        .padding(.vertical, 4)
                    }
                    .zIndex(5)
                }
                .background(colorSystem.color(colorCase: .background))
            }
            .background(colorSystem.color(colorCase: .background))
            .onChange(of: store.scrollToTop) { newValue in
                withAnimation {
                    proxy.scrollTo(scrollViewTopID)
                }
            }
        }
    }
    
    private func skeletonView() -> some View {
        VStack {
            ForEach(0...4, id: \.self) { _ in
                MoreCharacterSkeletonView()
                    .padding(.bottom, 10)
                    .shimmering(
                        gradient: Gradient(
                            colors:
                                [
                                    Color.black.opacity(0.3),
                                    Color.black.opacity(0.1),
                                    Color.black.opacity(0.3)
                                ]),
                        mode: .mask
                    )
            }
        }
        .padding(.horizontal, 12)
    }
    
    private func listContentView() -> some View {
        LazyVStack {
            ForEach(Array(store.state.videoInfos.enumerated()), id: \.element.id) { index, data in
                MoreCharacterListView(setModel: data)
                    .onAppear {
                        let count = store.state.videoInfos.count
                        let pageLimit = store.state.pageLimit
                        let trigger = store.state.currentData.listLoadTrigger
                        Task.detached {
                            print("------_@-------")
                            checkedMainThread()
                            if index >= count - pageLimit && trigger {
                                await store.send(.viewEventType(.videoOnAppear(index)))
                            }
                        }
                    }
                    .asButton { // 선택되었을때
                        store.send(.viewEventType(.selectedVideoIndex(index)))
                    }
                    .padding(.bottom, 10)
            }
        }
        .padding(.horizontal, 12)
        .background(colorSystem.color(colorCase: .background))
    }
    
    private func fakeSearchBar() -> some View {
        VStack {
            HStack {
                Text(Const.moreText)
                    .font(Font(WantedFont.regularFont.font(size: 15)))
                    .foregroundStyle(colorSystem.color(colorCase: .subTextColor))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.all, 12)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(colorSystem.color(colorCase: .pointColor), lineWidth: 1.4)
            }
        }
    }
}
#if DEBUG
#Preview {
    MoreCharacterView(store: Store(initialState: MoreCharacterFeature.State(), reducer: {
        MoreCharacterFeature()
    }))
}
#endif

