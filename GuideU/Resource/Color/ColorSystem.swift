//
//  ColorSystem.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/24/24.
//

import SwiftUI
import Combine

final class ColorSystem: @unchecked Sendable, ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published
    var currentColorSet: CurrentColorModeCase = CurrentColorModeCase(rawValue: UserDefaultsManager.colorCase) ?? .system
    
    @Published
    private var currentColorScheme: UIUserInterfaceStyle = .light
    
    init () {
        UserDefaults.standard
            .publisher(for: \.colorCase)
            .sink {[weak self] num in
                guard let self else { return }
                self.currentColorSet = CurrentColorModeCase(rawValue: num) ?? .system
            }
            .store(in: &cancellables)
        
        Task {
            await updateColorScheme()
        }
        
        NotificationCenter.default
            .publisher(for: UIScreen.brightnessDidChangeNotification, object: nil)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                   await self.updateColorScheme()
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                   await self.updateColorScheme()
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func updateColorScheme() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        guard let window = window else { return }
        let currentStyle = window.traitCollection.userInterfaceStyle
        print( currentStyle == .light ? "라이트 모드" : "다크 모드")
        self.currentColorScheme = currentStyle
    }
}


extension ColorSystem {
    
    enum ColorCase {
        case tabbar
        case background
        case textColor
        case subTextColor
        case cellBackground
        case shadowColor
        case pointColor
        case lineColor
        case detailGrayColor
        case subGrayColor
        case personSectionColor
        case personSectionTextColor
        case memeSectionColor
        case memeSectionTextColor
    }
    
    
    func color(colorCase: ColorCase) -> Color {
        switch colorCase {
        case .tabbar:
            switch currentColorSet {
            case .light:
                return Color(GuideUColor.tabbarColor.light.color)
            case .dark:
                return Color(GuideUColor.tabbarColor.dark.color)
            case .system:
                let light = Color(GuideUColor.tabbarColor.light.color)
                let dark = Color(GuideUColor.tabbarColor.dark.color)
                return currentColorScheme == .light ? light : dark
            }
        case .background:
            switch currentColorSet {
            case .light:
                return Color(GuideUColor.ViewBaseColor.light.backColor)
            case .dark:
                return Color(GuideUColor.ViewBaseColor.dark.backColor)
            case .system:
                let light = Color(GuideUColor.ViewBaseColor.light.backColor)
                let dark = Color(GuideUColor.ViewBaseColor.dark.backColor)
                return currentColorScheme == .light ? light : dark
            }
        case .textColor:
            switch currentColorSet {
            case .light:
                return Color(GuideUColor.ViewBaseColor.light.textColor)
            case .dark:
                return Color(GuideUColor.ViewBaseColor.dark.textColor)
            case .system:
                let light = Color(GuideUColor.ViewBaseColor.light.textColor)
                let dark = Color(GuideUColor.ViewBaseColor.dark.textColor)
                return currentColorScheme == .light ? light : dark
            }
        case .subTextColor:
            switch currentColorSet {
            case .light:
                return Color(GuideUColor.ViewBaseColor.light.gray2)
            case .dark:
                return Color(GuideUColor.ViewBaseColor.dark.gray2)
            case .system:
                let light = Color(GuideUColor.ViewBaseColor.light.gray2)
                let dark = Color(GuideUColor.ViewBaseColor.dark.gray2)
                return currentColorScheme == .light ? light : dark
            }
        case .cellBackground:
            switch currentColorSet {
            case .light:
                return Color(GuideUColor.ViewBaseColor.light.depth1)
            case .dark:
                return Color(GuideUColor.ViewBaseColor.dark.depth1)
            case .system:
                let light = Color(GuideUColor.ViewBaseColor.light.depth1)
                let dark = Color(GuideUColor.ViewBaseColor.dark.depth1)
                return currentColorScheme == .light ? light : dark
            }
        case .shadowColor:
            switch currentColorSet {
            case .light:
                return Color(UIColor(hexCode: "#000000")).opacity(0.125)
            case .dark:
                return Color(UIColor(hexCode: "#000000")).opacity(0.125)
            case .system:
                let light = Color(UIColor(hexCode: "#000000")).opacity(0.125)
                let dark = Color(UIColor(hexCode: "#000000")).opacity(0.125)
                return currentColorScheme == .light ? light : dark
            }
        case .pointColor:
            switch currentColorSet {
            case .light:
                return Color(GuideUColor.ViewBaseColor.light.primary)
            case .dark:
                return Color(GuideUColor.ViewBaseColor.dark.primary)
            case .system:
                let light = Color(GuideUColor.ViewBaseColor.light.primary)
                let dark = Color(GuideUColor.ViewBaseColor.dark.primary)
                return currentColorScheme == .light ? light : dark
            }
        case .lineColor:
            switch currentColorSet {
            case .light:
                return Color(GuideUColor.ViewBaseColor.light.lineType)
            case .dark:
                return Color(GuideUColor.ViewBaseColor.dark.lineType)
            case .system:
                let light = Color(GuideUColor.ViewBaseColor.light.lineType)
                let dark = Color(GuideUColor.ViewBaseColor.dark.lineType)
                return currentColorSet == .light ? light : dark
            }
        case .detailGrayColor:
            switch currentColorSet {
            case .light:
                return Color(GuideUColor.ViewBaseColor.light.gray1)
            case .dark:
                return Color(GuideUColor.ViewBaseColor.dark.gray1)
            case .system:
                let light = Color(GuideUColor.ViewBaseColor.light.gray1)
                let dark = Color(GuideUColor.ViewBaseColor.dark.gray1)
                return currentColorSet == .light ? light : dark
            }
        case .subGrayColor:
            switch currentColorSet {
            case .light:
                return Color(GuideUColor.ViewBaseColor.light.gray3)
            case .dark:
                return Color(GuideUColor.ViewBaseColor.dark.gray3)
            case .system:
                let light = Color(GuideUColor.ViewBaseColor.light.gray3)
                let dark = Color(GuideUColor.ViewBaseColor.dark.gray3)
                return currentColorSet == .light ? light : dark
            }
        case .personSectionColor:
            return Color(UIColor(hexCode: "#FFD2CF", alpha: 1))
            
        case .personSectionTextColor:
            return Color(UIColor(hexCode: "#5D1615", alpha: 1))
            
        case .memeSectionColor:
            return Color(UIColor(hexCode: "#DBEDDB"))
            
        case .memeSectionTextColor:
            return Color(UIColor(hexCode: "#1D3829"))
        }
    }
}


extension UserDefaults {
    @objc var colorCase: Int {
        get {
            return integer(forKey: UserDefaultsManager.Key.currentColorSetting.value)
        } set {
            set(newValue, forKey: UserDefaultsManager.Key.currentColorSetting.value)
        }
    }
}
