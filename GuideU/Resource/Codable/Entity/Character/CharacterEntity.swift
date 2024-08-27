//
//  CharacterEntity.swift
//  GuideU
//
//  Created by 김진수 on 8/27/24.
//

import Foundation

struct CharacterEntity: Entity {
    let name: String
    let engName: String
    let definition: String
    let smallImageUrl: String
    let largeImageUrl: String
    let links: [String]
    let id: Int
}
