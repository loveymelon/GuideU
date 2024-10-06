//
//  ShareViewModel.swift
//  YoutubeExtention
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
    
    // 익스텐션 종료와 메인앱 이동 관련 트리거 => UIKit
    let closeTrigger = PassthroughSubject<Void, Never> ()
    let openTrigger = PassthroughSubject<Void, Never> ()
    
    // MARK: Init
    init(state: State = State()) {
        self.state = state
    }
    
    struct State {
        var trigger = false
        var urlString: String? = nil
        var url: URL? = nil
    }
    
    enum Action {
        // View Action
        case ChangedTriggerState(Bool)
        case ifNSExtensionItemToUrl(NSExtensionItem)
        case justClose
        case moveToMainApp
        
        // binding
        case resultUrl(URL)
        case resultString(String)
        case resultFail
    }
    
    func send(_ action: Action) {
        switch action {
        case let .ChangedTriggerState(bool):
            state.trigger = bool
            
        case let .ifNSExtensionItemToUrl(item):
            if let items = item.attachments {
                Task {
                    if let url = await checkExtensionItemToURL(attachments: items) {
                        send(.resultUrl(url))
                    } else if let string = await checkExtensionItemToString(attachments: items) {
                        send(.resultString(string))
                    } else {
                        send(.resultFail)
                    }
                }
            }
        case .resultFail:
            // 종료
            print("fail")
            close()
            
        case let .resultUrl(url):
            state.url = url
            state.trigger = true
            
        case let .resultString(string):
            state.urlString = string
            state.trigger = true
            
        case .justClose:
            close()
            
        case .moveToMainApp:
            if let url = state.url {
                if processYouTubeURL(url) {
                    moveToMainApp()
                } else {
                    close()
                }
            } else if let string = state.urlString {
                if processYouTubeURL(string) {
                    moveToMainApp()
                } else {
                    close()
                }
            }
        }
    }
    
    // 종료
    private func close() {
        closeTrigger.send(())
    }
    // mainApp 이동
    private func moveToMainApp() {
        openTrigger.send(())
    }
    
    private func processYouTubeURL(_ url: URL) -> Bool {
        // 앱 그룹을 통해 메인 앱에 전달
        if let userDefaults = UserDefaults(suiteName: "group.guideu.youtube"),
           let encode = encoding(string: url.absoluteString) {
            
            userDefaults.setValue(encode, forKey: "sharedURL")
            print("공유받은 YouTube URL: \(url.absoluteString)")
            userDefaults.synchronize()
            
            return true
        } else {
            return false
        }
    }
    
    private func processYouTubeURL(_ string: String) -> Bool {
        
        // 앱 그룹을 통해 메인 앱에 전달
        if let userDefaults = UserDefaults(suiteName: "group.guideu.youtube"),
           let encode = encoding(string: string) {
            
            userDefaults.setValue(encode, forKey: "sharedURL")
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
    @MainActor
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
    
    @MainActor
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
