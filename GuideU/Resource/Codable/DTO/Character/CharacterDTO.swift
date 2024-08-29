//
//  CharactersDTO.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/20/24.
//

import Foundation

struct CharacterDTO: DTO {
    let name: String
    let engName: String
    let definition: String
    let smallImageUrl: String
    let largeImageUrl: String
    let links: [LinkDTO]?
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case engName = "eng_name"
        case definition
        case smallImageUrl = "small_image_url"
        case largeImageUrl = "large_image_url"
        case links
        case id
    }
}

struct CharactersDTO: DTO {
    let charactersDTO: [CharacterDTO]
    
    init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var characterList = [CharacterDTO] ()
        while !container.isAtEnd {
            let character = try container.decode(CharacterDTO.self)
            characterList.append(character)
        }
        self.charactersDTO = characterList
    }
}
