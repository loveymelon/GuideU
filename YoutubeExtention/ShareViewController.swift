//
//  ShareViewController.swift
//  YoutubeExtention
//
//  Created by Jae hyung Kim on 9/6/24.
//

import SwiftUI
import Social
import Combine
import UniformTypeIdentifiers

final class ShareViewController: UIViewController {
    
    private var viewModel = SharedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        handleSharedURL()
    }
    
    private func setting() {
        // Swift UI
        let sharedView = SharedForYoutubeView(viewModel: viewModel) { [ weak self ] in
            self?.openMainApp()
        } justClose: { [weak self] in
            self?.close()
        }
        
        let hostingController = UIHostingController(rootView: sharedView)
        hostingController.view.backgroundColor = UIColor(white: 0, alpha: 0.23)
//        view.backgroundColor = .clear
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        setLayout(viewCon: hostingController)
    }
    
    private func setLayout(viewCon: UIViewController) {
        NSLayoutConstraint.activate([
            viewCon.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewCon.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewCon.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewCon.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        viewCon.didMove(toParent: self)
    }
    
    private func handleSharedURL() {
        // 공유된 항목 가져오기
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            if let attachments = item.attachments {
                for provider in attachments {
                    // URL을 처리하기 위한 타입 확인
                    if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                        provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { (item, error) in
                            if let url = item as? URL {
                                // YouTube URL 확인 및 처리
                                self.processYouTubeURL(url)
                            }
                        }
                    } else if provider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
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
        // 앱 그룹을 통해 메인 앱에 전달
        if let userDefaults = UserDefaults(suiteName: "group.guideu.youtube") {
            userDefaults.set(url.absoluteString, forKey: "sharedURL")
        }
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.trigger = true
        }
    }
    private func processYouTubeURL(_ string: String) {
        print("공유받은 YouTube URL: \(string)")
        
        // 앱 그룹을 통해 메인 앱에 전달
        if let userDefaults = UserDefaults(suiteName: "group.guideu.youtube") {
            userDefaults.set(string, forKey: "sharedURL")
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.trigger = true
        }
    }
    
    private func close() {
        // Share Extension 종료 및 앱 이동
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    private func openMainApp() {
        let urlScheme = "guideu://"
        if let url = URL(string: urlScheme) {
            // 앱 실행
            if self.openURL(url) {
                print( "RUN : APP")
            } else {
                print( "NOT RUN : APP")
            }
            close()
        }
    }
    
    @objc private func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}

final class SharedViewModel: ObservableObject {
    @Published var trigger = false
}
