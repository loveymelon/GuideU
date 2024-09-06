//
//  ShareViewController.swift
//  YoutubeExtention
//
//  Created by Jae hyung Kim on 9/6/24.
//

import UIKit
import Social
import UniformTypeIdentifiers

final class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        handleSharedURL()
    }
    
    private func handleSharedURL() {
        // 공유된 항목 가져오기
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            view.backgroundColor = .blue
            if let attachments = item.attachments {
                view.backgroundColor = .green
                for provider in attachments {
                    // URL을 처리하기 위한 타입 확인
                    if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                        view.backgroundColor = .red
                        provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { (item, error) in
                            if let url = item as? URL {
                                // YouTube URL 확인 및 처리
                                self.processYouTubeURL(url)
                            }
                        }
                    } else if provider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
                        view.backgroundColor = .darkGray
                        
                        provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { (item, error) in
                            if let url = item as? String {
                                // YouTube URL 확인 및 처리
                                self.processYouTubeURL(url)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func processYouTubeURL(_ url: URL) {
        // YouTube URL을 처리하거나, 앱으로 전달하는 로직
        print("공유받은 YouTube URL: \(url.absoluteString)")
        view.backgroundColor = .red
        // 앱 그룹을 통해 메인 앱에 전달
        if let userDefaults = UserDefaults(suiteName: "group.guideu.youtube1") {
            userDefaults.set(url.absoluteString, forKey: "sharedURL")
        }
        if let userDefaults = UserDefaults(suiteName: "group.guideu.youtube2") {
            userDefaults.set(url.absoluteString, forKey: "sharedURL")
        }
    }
    private func processYouTubeURL(_ string: String) {
        print("공유받은 YouTube URL: \(string)")
        view.backgroundColor = .red
        // 앱 그룹을 통해 메인 앱에 전달
        if let userDefaults = UserDefaults(suiteName: "group.GuidU.Youtube") {
            userDefaults.set(string, forKey: "sharedURL")
        }
    }
    
    private func close() {
        // Share Extension 종료
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    
}
