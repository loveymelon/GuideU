//
//  ContentView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var tabSelected = TabCase.home
    
    @Environment(\.colorScheme) var scheme
    
    /// Splash -> 처음 유저인지 UserDefaults Trigger -> 온보딩뷰 or TabView
    var body: some View {
        Text("임시")
    }
}

#Preview {
    ContentView()
}
