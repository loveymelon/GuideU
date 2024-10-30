//
//  ViewWrappingUIKitCellView.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/30/24.
//

import SwiftUI

final class ViewWrappingUIKitCellView: UICollectionViewCell, ReusableIdentifier {
    private weak var hostingController: UIHostingController<AnyView>?
    
    func configure(with view: AnyView) {
        if let hostingController = hostingController {
            hostingController.rootView = view
        } else {
            let hostingController = UIHostingController(rootView: view)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
            self.hostingController = hostingController
        }
    }
}
