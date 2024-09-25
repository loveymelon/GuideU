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
    
    var body: some View {
        WithPerceptionTracking {
            TabView(selection: $store.currentTab.sending(\.tabCase)) {
                Group {
                    
                    HomeCoordinatorView(
                        store: store.scope(
                            state: \.homeTabState,
                            action: \.homeTabAction
                        )
                    )
                    .environmentObject(colorSystem)
                    .tabItem {
                        tabItemView(tabItem: .home)
                    }
                    .tag(TabCase.home)
                    .toolbarBackground(colorSystem.color(colorCase: .tabbar).opacity(0.9), for: .tabBar)
                    
                    SearchCoordinatorView(
                        store: store.scope(
                            state: \.searchTabState,
                            action: \.searchTabAction
                        )
                    )
                    .environmentObject(colorSystem)
                    .tabItem {
                        tabItemView(
                            tabItem: .searchTab
                        )
                    }
                    .tag(
                        TabCase.searchTab
                    )
                    .toolbarBackground(colorSystem.color(colorCase: .tabbar).opacity(0.9), for: .tabBar)
                    
                    HistoryCoordinatorView(
                        store: store.scope(
                            state: \.historyTabState,
                            action: \.historyTabAction
                        )
                    )
                    .environmentObject(colorSystem)
                    .tabItem {
                        tabItemView(tabItem: .timeLine)
                    }
                    .tag(TabCase.timeLine)
                    .toolbarBackground(colorSystem.color(colorCase: .tabbar).opacity(0.9), for: .tabBar)
                    
                    SettingCoordinatorView(
                        store: store.scope(
                            state: \.settingTabState,
                            action: \.settingTabAction
                        )
                    )
                    .environmentObject(colorSystem)
                    .tabItem {
                        tabItemView(tabItem: .setting)
                    }
                    .tag(TabCase.setting)
                    .toolbarBackground(colorSystem.color(colorCase: .tabbar).opacity(0.9), for: .tabBar)
                }
            }
        }
    }
}

extension GuideUTabView {
    
    private func tabItemView(tabItem: TabCase) -> some View {
        VStack {
            Spacer(minLength: 20)
                Text("")
            Group {
                switch tabItem {
                case .home:
                    
                    store.currentTab == .home ? Image.TabbarImage.selected.homeTab : Image.TabbarImage.noneTab.homeTab
                        .renderingMode(.template)
                        .resizable()
                    
                case .searchTab:
                    store.currentTab == .searchTab ? Image.TabbarImage.selected.searchTab : Image.TabbarImage.noneTab.searchTab
                        .renderingMode(.template)
                        .resizable()
                case .timeLine:
                    store.currentTab == .timeLine ? Image.TabbarImage.selected.historyTab : Image.TabbarImage.noneTab.historyTab
                        .renderingMode(.template)
                        .resizable()
                case .setting:
                    store.currentTab == .setting ? Image.TabbarImage.selected.settingTab : Image.TabbarImage.noneTab.settingTab
                        .renderingMode(.template)
                        .resizable()
                }
            }
            .frame(width: 10)
            .aspectRatio(1, contentMode: .fit)
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
