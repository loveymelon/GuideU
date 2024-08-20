//
//  MessageDTO.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/20/24.
//

import Foundation

enum LocDTO: DTO {
    case integer(Int)
    case string(String)
    
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(LocDTO.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for LocDTO"))
    }
}
