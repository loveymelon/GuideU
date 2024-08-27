//
//  CharacterMapper.swift
//  GuideU
//
//  Created by 김진수 on 8/27/24.
//

import Foundation
import ComposableArchitecture

struct CharacterMapper {
    /// CharacterDTO -> Entity
    func dtoToEntity(_ dto: CharactersDTO) -> CharacterEntity {
        return CharacterEntity(name: dto.name, engName: dto.engName, definition: dto.definition, smallImageUrl: dto.smallImageUrl, largeImageUrl: dto.largeImageUrl, links: dto.links, id: dto.id)
    }
}

extension CharacterMapper: DependencyKey {
    static var liveValue: CharacterMapper = CharacterMapper()
}

extension DependencyValues {
    var characterMapper: CharacterMapper {
        get { self[CharacterMapper.self] }
        set { self[CharacterMapper.self] = newValue }
    }
}
