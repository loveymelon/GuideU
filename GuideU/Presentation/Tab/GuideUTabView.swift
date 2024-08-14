//
//  TabView.swift
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
        TabView(selection: $store.currentTab.sending(\.임시)) {
            Group {
                Text("as")
                    .tabItem {
                        tabItemView(tabItem: .home)
                    }
                    .tag(TabCase.home)
                    
                Text("ass")
                    .tabItem {
                        tabItemView(tabItem: .meme)
                    }
                    .tag(TabCase.meme)
                   
                Text("asss")
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
                UITabBar.appearance().backgroundColor = GuideUColor.tabbarColor.dark.color
            @unknown default:
                break
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
                    
                case .meme:
                    store.currentTab == .meme ? Image.TabbarImage.selected.memeTab : Image.TabbarImage.noneTab.memeTab
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
