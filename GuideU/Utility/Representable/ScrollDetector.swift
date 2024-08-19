//
//  ScrollDetector.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/19/24.
//

import SwiftUI

struct ScrollDetector: UIViewRepresentable {
    var onScroll: (CGFloat) -> ()
    var onDraggingEnd: (CGFloat, CGFloat) -> ()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            /// uiView          .superview?     .superview?.superview
            /// Background .backgroud { } . VState{ }, . ScrollView { }
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView,
               !context.coordinator.isDelegateAdded {
                scrollView.delegate = context.coordinator
                context.coordinator.isDelegateAdded = true
            }
        }
    }
    
    final class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollDetector
        
        init(_ parent: ScrollDetector) {
            self.parent = parent
        }
        // 딜리게이트 한번만 할수 있도록한 트리거
        var isDelegateAdded: Bool = false
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.onScroll(scrollView.contentOffset.y)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            parent.onDraggingEnd(targetContentOffset.pointee.y, velocity.y)
        }
        
    }
}
