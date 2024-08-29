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
}

extension SearchRouter {
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "/api/v1/search"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .search:
            return HTTPHeaders([
                HTTPHeader(name: "Content-Type", value: "application/json")
            ])
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .search(searchText):
            return ["query": searchText]
        }
    }
    
    var body: Data? {
        switch self {
        case .search:
            return nil
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .search:
            return .url
        }
    }
}
