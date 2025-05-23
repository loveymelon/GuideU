//
//  ShareViewController.swift
//  GuideUShareExtension
//
//  Created by Jae hyung Kim on 10/6/24.
//

import SwiftUI
import Combine

final class ShareViewController: UIViewController {
    
    private let viewModel = ShareViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let input = makeInput()
        
        setting(input: input) // UI Setting
        subscribe(input: input)
        
    }
    
    private func setting(input: ShareViewModel.Input) {
        // Swift UI
        let sharedView = ShareView(moveToMainApp: {
            input.moveToMainApp
                .send(())
        }, justClose: { [weak self] in
            guard let self else { return }
            close()
        })
            .environmentObject(viewModel)
        
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
}

extension ShareViewController {
    
    private func makeInput() -> ShareViewModel.Input {
        let nsExtensionItem = PassthroughSubject<NSExtensionItem, Never> ()
        
        let input = ShareViewModel.Input(nsExtensionItem: nsExtensionItem)
        
        return input
    }
    
    private func subscribe(input: ShareViewModel.Input) {
        let output = viewModel.body(input)
        
        sendAction(input: input)
        getAction(output: output)
    }
    
    private func sendAction(input: ShareViewModel.Input) {
        
        // MARK: 공유하기를 통해 item을 받음을 감지
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            input.nsExtensionItem
                .send(item)
        }
    }
    
    private func getAction(output: ShareViewModel.Output) {
        
        // MARK: mainApp 오픈 트리거
        output
            .openTrigger
            .guardSelf(self)
            .sink { owner, _ in
                owner.openMainApp()
            }
            .store(in: &viewModel.cancellables)
        
        // MARK: 공유하기 닫기 트리거
        output.closeTrigger
            .guardSelf(self)
            .sink { owner, _ in
                owner.close()
            }
            .store(in: &viewModel.cancellables)
    }
}

// MARK: Open App
extension ShareViewController {
    private func openMainApp() {
        let urlScheme = viewModel.state.guideUUrlScheme
        if let url = URL(string: urlScheme) {
            // 앱 실행
            if self.openURL(url) {
                #if DEBUG
                print("RUN : APP")
                #endif
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
