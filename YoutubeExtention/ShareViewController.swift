//
//  ShareViewController.swift
//  YoutubeExtention
//
//  Created by Jae hyung Kim on 9/6/24.
//

import SwiftUI
import Social
import Combine
import AppIntents

final class ShareViewController: UIViewController {
    
    private let viewModel = ShareViewModel()
    
//    init(viewModel: ShareViewModel = ShareViewModel()) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting() // UI Setting
        handleSharedURL() // URL Logic Start
        subscribe() // Combine Sink
    }
    
    private func setting() {
        // Swift UI
        let sharedView = SharedForYoutubeView(viewModel: viewModel)
        
        let hostingController = UIHostingController(rootView: sharedView)
        hostingController.view.backgroundColor = UIColor(white: 0, alpha: 0.23)
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
            viewModel.send(.ifNSExtensionItemToUrl(item))
        }
    }
}

extension ShareViewController {
    private func subscribe() {
        viewModel.closeTrigger
            .sink { [weak self] in
                self?.close()
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.openTrigger
            .sink { [weak self] in
                self?.openMainApp()
            }
            .store(in: &viewModel.cancellables)
    }
}

// MARK: Open App
extension ShareViewController {
    private func openMainApp() {
        let urlScheme = "GuideU://"
        if let url = URL(string: urlScheme) {
            // 앱 실행
            if self.openURL(url) {
                print("RUN : APP")
            }
            close()
        }
    }
      
    
    @objc private func openURL(_ url: URL) -> Bool {
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

// MARK: Close
extension ShareViewController {
    private func close() {
        // Share Extension 종료 및 앱 이동
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
