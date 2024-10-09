//
//  ShareViewModel.swift
//  GuideUShareExtension
//
//  Created by Jae hyung Kim on 10/6/24.
//

@preconcurrency import Foundation //  SE-0414 (지역 기반 격리) 이슈로 안한
import Combine
import UniformTypeIdentifiers

@MainActor
final class ShareViewModel: ObservableObject {
    
    @Published
    private(set) var state: State
    
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: Init
    init(state: State = State()) {
        self.state = state
    }
    
    struct Input {
        let nsExtensionItem: PassthroughSubject<NSExtensionItem, Never>
        let moveToMainApp = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let closeTrigger: PassthroughSubject<Void, Never>
        let openTrigger: PassthroughSubject<Void, Never>
    }
    
    struct State {
        var trigger = false
        var url: URL? = nil
        var string: String? = nil
        let guideUUrlScheme = GuideUShareConst.urlScheme
        let loadingText = GuideUShareConst.ShareViewText.loading
        let checkedText = GuideUShareConst.ShareViewText.checkedGuide
    }
    
    func body(_ input: Input) -> Output {
        let resultUrl = PassthroughSubject<URL, Never> ()
        let resultString = PassthroughSubject<String, Never> ()
        let resultFail = PassthroughSubject<Void, Never> ()
        
        
        //output
        let closeOutput = PassthroughSubject<Void, Never> ()
        let openOutput = PassthroughSubject<Void, Never> ()
        
        input.nsExtensionItem
            .sink { [weak self] item in
                guard let self else { return }
                if let items = item.attachments {
                    Task {
                        if let url = await self.checkExtensionItemToURL(attachments: items) {
                            resultUrl.send(url)
                        } else if let string = await self.checkExtensionItemToString(attachments: items) {
                            resultString.send(string)
                        } else {
                            resultFail.send(())
                        }
                    }
                }
            }.store(in: &cancellables)
        
        input.moveToMainApp
            .sink { [weak self] _ in
                guard let self else { return }
                
                if let url = state.url {
                    if !processYouTubeURL(url) {
                        closeOutput.send(())
                    } else {
                        openOutput.send(())
                    }
                } else if let string = state.string {
                    if !processYouTubeURL(string) {
                        closeOutput.send(())
                    } else {
                        openOutput.send(())
                    }
                } else {
                    closeOutput.send(())
                }
            }.store(in: &cancellables)
        
        resultUrl.sink { [weak self] url in
            guard let self else { return }
            state.url = url
            state.trigger = true
            
        }.store(in: &cancellables)
        
        resultString.sink { [weak self] string in
            guard let self else { return }
            
            state.string = string
            state.trigger = true
        }.store(in: &cancellables)
        
        resultFail.sink { _ in
            closeOutput.send(())
            
        }.store(in: &cancellables)
        
        return Output(closeTrigger: closeOutput, openTrigger: openOutput)
    }
    
    private func processYouTubeURL(_ url: URL) -> Bool {
        // 앱 그룹을 통해 메인 앱에 전달
        if let userDefaults = UserDefaults(suiteName: GuideUShareConst.appGroupID),
           let encode = encoding(string: url.absoluteString) {
            
            userDefaults.setValue(encode, forKey: GuideUShareConst.userDefaultKey)
            print("공유받은 YouTube URL: \(url.absoluteString)")
            userDefaults.synchronize()
            
            return true
        } else {
            return false
        }
    }
    
    private func processYouTubeURL(_ string: String) -> Bool {
        
        // 앱 그룹을 통해 메인 앱에 전달
        if let userDefaults = UserDefaults(suiteName: GuideUShareConst.appGroupID),
           let encode = encoding(string: string) {
            
            userDefaults.setValue(encode, forKey: GuideUShareConst.userDefaultKey)
            print("공유받은 YouTube URL: \(string)")

            userDefaults.synchronize()
            return true
        } else {
            return false
        }
    }
    
    private func encoding(string: String) -> Data? {
        return try? JSONEncoder().encode(string)
    }
}

extension ShareViewModel {
    /*
     https://github.com/swiftlang/swift-evolution/blob/main/proposals/0414-region-based-isolation.md
     SE-0414 (지역 기반 격리) 현재 미출시
     */
    private func checkExtensionItemToURL(attachments: [NSItemProvider]) async -> URL? {
        for provider in attachments {
            if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                do {
                    let result = try await provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil)
                    guard let url = result as? URL else { return nil }
                    return url
                } catch {
                    return nil
                }
            }
        }
        return nil
    }
    
    private func checkExtensionItemToString(attachments: [NSItemProvider]) async -> String? {
        for provider in attachments {
            do {
                let result = try await provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil)
                if let string = result as? String {
                    return string
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}
