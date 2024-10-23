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

struct MoreCharacterView: View {
    
    @Perception.Bindable var store: StoreOf<MoreCharacterFeature>
    
    @Environment(\.openURLManager) var openURLManager
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    @State var dropdown: Bool = false
    
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
                    .id(store.scrollViewTopID)
                ZStack(alignment: .top) {
                    ZStack {
                        Group {
                            if store.state.loadingTrigger {
                                skeletonView()
                            } else {
                                listContentView()
                            }
                        }
                        .background(colorSystem.color(colorCase: .background))
                        .padding(.top, 120)
                    }
                    ZStack {
                        wantMoreInfoView()
                            .padding(.top, 20)
                            .padding(.vertical, 4)
                    }
                    .zIndex(100)
                }
                .background(colorSystem.color(colorCase: .background))
            }
            .background(colorSystem.color(colorCase: .background))
            .onChange(of: store.scrollToTop) { newValue in
                withAnimation {
                    proxy.scrollTo(store.scrollViewTopID)
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
            ForEach(Array(store.videoInfos.enumerated()), id: \.element.id) { index, data in
                MoreCharacterListView(setModel: data)
                    .asButton { // 선택되었을때
                        store.send(.viewEventType(.selectedVideoIndex(index)))
                    }
                    .environmentObject(colorSystem)
                    .padding(.bottom, 10)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            if index >= store.state.videoInfos.count - 8 {
                                if store.state.listLoadTrigger {
                                    store.send(.viewEventType(.videoOnAppear(index)))
                                }
                            }
                        }
                    }
            }
        }
        .padding(.horizontal, 12)
        .background(colorSystem.color(colorCase: .background))
    }
    
    private func wantMoreInfoView() -> some View {
        VStack(spacing: 0) {
            Text(
                store.constViewState.main.styledText(
                    fullFont: WantedFont.regularFont.font(size: 22),
                    fullColor: UIColor(colorSystem.color(colorCase: .textColor)),
                    targetString: store.constViewState.targetString,
                    targetFont: WantedFont.boldFont.font(size: 24),
                    targetColor: GuideUColor.ViewBaseColor.light.primary
                )
            )
            
            HStack(alignment: .top, spacing: 4) {
                DropDownMenu(
                    options: store.dropDownOptions.map(
                        {
                            $0.menuTitle
                        }),
                    selectedOptionIndex: $store.currentIndex.sending(
                        \.currentIndex
                    ),
                    showDropdown: $dropdown
                )
                .frame(width: 110)
                .environmentObject(colorSystem)
                .zIndex(100)
                
                Text(store.constViewState.sub)
                    .font(Font(WantedFont.regularFont.font(size: 22)))
                    .padding(.top, 10)
                    .foregroundStyle(colorSystem.color(colorCase: .textColor))
            }
            
        }
    }
    
    private func fakeSearchBar() -> some View {
        VStack {
            HStack {
                Text(store.constViewState.placeHolder)
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

