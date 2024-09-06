//
//  WKWebHosting.swift
//  GuideU
//
//  Created by 김진수 on 9/6/24.
//

import SwiftUI
import WebKit

struct WKWebHosting: UIViewRepresentable {
    var url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url else {
            return WKWebView()
        }
        let webView = WKWebView()

        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<WKWebHosting>) {
        guard let url else { return }
        webView.load(URLRequest(url: url))
    }
}
