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
    
    @Environment(\.colorScheme) var scheme
    
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
                    .tabItem {
                        tabItemView(tabItem: .home)
                    }
                    .tag(TabCase.home)

                    SearchCoordinatorView(
                        store: store.scope(
                            state: \.searchTabState,
                            action: \.searchTabAction
                        )
                    )
                    .tabItem {
                        tabItemView(
                            tabItem: .searchTab
                        )
                    }
                    .tag(
                        TabCase.searchTab
                    )
                    
                    HistoryCoordinatorView(
                        store: store.scope(
                            state: \.historyTabState,
                            action: \.historyTabAction
                        )
                    )
//                    Text("asdasd")
                    .tabItem {
                        tabItemView(tabItem: .timeLine)
                    }
                    .tag(TabCase.timeLine)
                    
                    
                    Text("assss")
                        .tabItem {
                            tabItemView(tabItem: .setting)
                        }
                        .tag(TabCase.setting)
                }
            }
            .onAppear {
                switch scheme {
                case .light:
                    UITabBar.appearance().backgroundColor = GuideUColor.tabbarColor.light.color
                case .dark:
//                    UITabBar.appearance().backgroundColor = GuideUColor.tabbarColor.dark.color
                    UITabBar.appearance().backgroundColor = GuideUColor.tabbarColor.light.color
                @unknown default:
                    break
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
