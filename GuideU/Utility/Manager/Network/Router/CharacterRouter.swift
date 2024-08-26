//
//  CharacterRouter.swift
//  GuideU
//
//  Created by 김진수 on 8/26/24.
//

import Foundation
import Alamofire

enum CharacterRouter: Router {
    case fetchCharacterList(limit: Int, offset: Int, start: String)
}

extension CharacterRouter {
    var method: HTTPMethod {
        switch self {
        case .fetchCharacterList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchCharacterList:
            return GuideUURL.baseURLString + "/api/v1/characters"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .fetchCharacterList:
            return nil
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .fetchCharacterList(limit, offset, start):
            return [
                    "limit": limit,
                    "offset": offset,
                    "starts_with": start
                    ]
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchCharacterList:
            return nil
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .fetchCharacterList:
            return .url
        }
    }
}
