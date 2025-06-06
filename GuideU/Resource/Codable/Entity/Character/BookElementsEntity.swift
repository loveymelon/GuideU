//
//  BookElementsEntity.swift
//  GuideU
//
//  Created by 김진수 on 9/10/24.
//

import Foundation

struct BookElementsEntity: Entity, Identifiable {
    let id = UUID()
    
    let timestamp: String
    let memes: [MemeEntity]
}
