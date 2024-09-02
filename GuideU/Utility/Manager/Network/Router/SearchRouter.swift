//
//  SearchRouter.swift
//  GuideU
//
//  Created by 김진수 on 8/29/24.
//

import Foundation
import Alamofire

enum SearchRouter: Router {
    case search(searchText: String)
    case suggest(searchText: String)
}

extension SearchRouter {
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        case .suggest:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "/api/v1/search"
        case .suggest:
            return "/api/v1/suggest"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .search:
            return HTTPHeaders([
                HTTPHeader(name: "Content-Type", value: "application/json")
            ])
        case .suggest:
            return nil
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .search(searchText):
            return ["query": searchText]
        case let .suggest(searchText):
            return ["query": searchText]
        }
    }
    
    var body: Data? {
        switch self {
        case .search:
            return nil
        case .suggest:
            return nil
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .search:
            return .url
        case .suggest:
            return .url
        }
    }
}
