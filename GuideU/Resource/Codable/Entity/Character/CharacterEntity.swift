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
    let smallImageUrl: URL?
    let largeImageUrl: URL?
    let links: [LinkEntity]?
    let id: Int
}

struct YoutubeCharacterEntity: Entity, Identifiable {
    let id = UUID()
    
    let name, engName, definition: String
    let smallImageURL: URL?
    let largeImageURL: URL?
    let links: [LinkEntity]
}
