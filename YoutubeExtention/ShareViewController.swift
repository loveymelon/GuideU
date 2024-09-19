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
import AppIntents

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
        // 앱 그룹을 통해 메인 앱에 전달
        if let userDefaults = UserDefaults(suiteName: "group.guideu.youtube"),
           let encode = encoding(string: url.absoluteString) {
            
            userDefaults.setValue(encode, forKey: "sharedURL")
            print("공유받은 YouTube URL: \(url.absoluteString)")

            userDefaults.synchronize()
            
            DispatchQueue.main.async { [weak self] in
                self?.viewModel.trigger = true
            }
        } else {
            close()
        }
    }
    
    private func processYouTubeURL(_ string: String) {
        
        // 앱 그룹을 통해 메인 앱에 전달
        if let userDefaults = UserDefaults(suiteName: "group.guideu.youtube"),
           let encode = encoding(string: string) {
            
            userDefaults.setValue(encode, forKey: "sharedURL")
            print("공유받은 YouTube URL: \(string)")

            userDefaults.synchronize()
            
            DispatchQueue.main.async { [weak self] in
                self?.viewModel.trigger = true
            }
        } else {
            close()
        }
    }
    
    private func encoding(string: String) -> Data? {
        return try? JSONEncoder().encode(string)
    }
    
    private func close() {
        // Share Extension 종료 및 앱 이동
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    private func openMainApp() {
        let urlScheme = "GuideU://"
        if let url = URL(string: urlScheme) {
            // 앱 실행
            if self.openURL(url) {
                print( "RUN : APP")
            } else {
                if let url = (URL(string: urlScheme)) {
                    if #available(iOS 17, *) {
                        iOS18ECCEPT(url: url)
                    }
                }
            }
            close()
        }
    }
    
    @available(iOS 17, *)
    private func iOS18ECCEPT(url : URL) {
        if !self.openURL2(url) {
            print( "NOT RUN : APP")
        } else {
            
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
    
    @objc private func openURL2(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                application.open(url, options: [:], completionHandler: nil)
                return true
            }
            responder = responder?.next
        }
        return false
    }

}

final class SharedViewModel: ObservableObject {
    @Published var trigger = false
}
