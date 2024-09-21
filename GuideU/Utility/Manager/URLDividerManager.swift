//
//  URLDividerManager.swift
//  GuideU
//
//  Created by 김진수 on 9/12/24.
//

import Foundation
import ComposableArchitecture

struct URLDividerManager: Sendable {
    
    enum URLTypeCheck {
        case youtubeIdentifier(String)
    }
    
    func dividerResult(type: URLTypeCheck) -> String? {
        switch type {
        case .youtubeIdentifier(let string):
            return youtube(string)
        }
    }
}

extension URLDividerManager {
    private func youtube(_ urlString: String) -> String? {
        guard let url = URL(string: urlString),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }

        if let vValue = queryItems.first(where: { $0.name == "v" })?.value {
            return vValue
        } else if let siValue = queryItems.first(where: { $0.name == "si" })?.value {
            return siValue
        } else {
            return nil
        }
    }
}

extension URLDividerManager: DependencyKey {
    static let liveValue = Self()
}

extension DependencyValues {
    var urlDividerManager: URLDividerManager {
        get { self[URLDividerManager.self] }
        set { self[URLDividerManager.self] = newValue }
    }
}
