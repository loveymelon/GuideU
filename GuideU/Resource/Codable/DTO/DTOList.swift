//
//  MemeDTOList.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import Foundation

/// 이름없는 DTO
/// 사용시 (dto: DTOList<MemeDTO>.self) 같이
struct DTOList<D: DTO>: DTO {
    
    let elements: [D]
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements = [D] ()
        while !container.isAtEnd {
            let element = try container.decode(D.self)
            elements.append(element)
        }
        self.elements = elements
    }
}
