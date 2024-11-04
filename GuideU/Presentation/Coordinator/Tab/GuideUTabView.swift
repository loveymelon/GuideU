//
//  GuideUTabView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/12/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

struct GuideUTabView: View {
    
    @Perception.Bindable var store: StoreOf<TabCoordinator>
    
    @EnvironmentObject var colorSystem: ColorSystem
    
    private var rows: [GridItem] = Array(repeating: GridItem(.flexible()), count: TabCase.allCases.count)
    
    private let hapticManager: HapticFeedbackManager
    
    init(store: StoreOf<TabCoordinator>) {
        self.store = store
        self.hapticManager = HapticFeedbackManager()
    }
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                TabView(selection: $store.currentTab.sending(\.tabCase)) {
                    tabContentView()
                }
                .overlay(alignment: .bottom) {
                    customTabBarView()
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

extension GuideUTabView {

    private func customTabBarView() -> some View {
        VStack {
            LazyVGrid(columns: rows) {
                ForEach(TabCase.allCases, id: \.self) { caseOf in
                    tabItemView(tabItem: caseOf)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .fixedSize()
                        .asButton {
                            hapticManager.impact(style: .soft)
                            store.send(.tabCase(caseOf))
                        }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .padding(.bottom, 30)
        .background(colorSystem.color(colorCase: .tabbar))
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear

            // 경계선(검정색 줄) 제거
            appearance.shadowImage = UIImage()
            appearance.backgroundImage = UIImage()
            appearance.shadowColor = .clear

            // 설정 적용
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    private func tabItemView(tabItem: TabCase) -> some View {
        let current = store.currentTab
        let this = tabItem
        
        return Group {
            switch tabItem {
            case .home:
                Image(ImageType.TabImage.NormalImage.home)
                    .renderingMode(.template)
                    .resizable()
            case .searchTab:
                Image(ImageType.TabImage.NormalImage.search)
                    .renderingMode(.template)
                    .resizable()
            case .timeLine:
                Image(ImageType.TabImage.NormalImage.history)
                    .renderingMode(.template)
                    .resizable()
            case .setting:
                Image(ImageType.TabImage.NormalImage.setting)
                    .renderingMode(.template)
                    .resizable()
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .foregroundStyle( current == this ? colorSystem.color(colorCase: .pointColor) : colorSystem.color(colorCase: .detailGrayColor))
        .toolbar(.hidden, for: .bottomBar)
    }
}

extension GuideUTabView {
    private func tabContentView() -> some View {
        Group {
            
            HomeCoordinatorView(
                store: store.scope(
                    state: \.homeTabState,
                    action: \.homeTabAction
                )
            )
            .environmentObject(colorSystem)
            .tag(TabCase.home)
            
            SearchCoordinatorView(
                store: store.scope(
                    state: \.searchTabState,
                    action: \.searchTabAction
                )
            )
            .environmentObject(colorSystem)
            .tag(
                TabCase.searchTab
            )
            
            HistoryCoordinatorView(
                store: store.scope(
                    state: \.historyTabState,
                    action: \.historyTabAction
                )
            )
            .environmentObject(colorSystem)
            .tag(TabCase.timeLine)
            
            SettingCoordinatorView(
                store: store.scope(
                    state: \.settingTabState,
                    action: \.settingTabAction
                )
            )
            .environmentObject(colorSystem)
            .tag(TabCase.setting)
        }
    }
}

#if DEBUG
#Preview {
    GuideUTabView(store: Store(initialState: TabCoordinator.State(), reducer: {
        TabCoordinator()
    }))
}
#endif
