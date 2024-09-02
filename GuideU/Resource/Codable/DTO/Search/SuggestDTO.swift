//
//  SuggestDTO.swift
//  GuideU
//
//  Created by 김진수 on 9/2/24.
//

import Foundation

struct SuggestDTO: DTO {
    let type: String
    let keyword: String
}

struct SuggestListDTO: DTO {
    let suggestDTO: [SuggestDTO]
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var suggestList = [SuggestDTO] ()
        while !container.isAtEnd {
            let suggest = try container.decode(SuggestDTO.self)
            suggestList.append(suggest)
        }
        self.suggestDTO = suggestList
    }
}
