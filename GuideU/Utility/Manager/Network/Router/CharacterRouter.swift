//
//  CharacterRouter.swift
//  GuideU
//
//  Created by 김진수 on 8/26/24.
//

import Foundation
import Alamofire

enum CharacterRouter: Router {
    case fetchCharacterList(limit: Int, offset: Int, start: String?)
    case fetchCharacter(Int)
}

extension CharacterRouter {
    var method: HTTPMethod {
        switch self {
        case .fetchCharacterList:
            return .get
        case .fetchCharacter:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchCharacterList:
            return "/api/v1/characters"
        case let .fetchCharacter(id):
            return "/api/v1/characters/\(id)"
        }
    }
    
    var optionalHeaders: HTTPHeaders? {
        switch self {
        case .fetchCharacterList, .fetchCharacter:
            return HTTPHeaders([
                HTTPHeader(name: "Content-Type", value: "application/json")
            ])
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .fetchCharacterList(limit, offset, start):
            
            if let start {
                return [
                        "limit": limit,
                        "offset": offset,
                        "starts_with": start
                        ]
            } else {
                return [
                        "limit": limit,
                        "offset": offset
                        ]
            }
        case .fetchCharacter:
            return nil
            
            
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchCharacterList, .fetchCharacter:
            return nil
        }
    }
    
    var encodingType: EncodingType {
        switch self {
        case .fetchCharacterList, .fetchCharacter:
            return .url
        }
    }
}
