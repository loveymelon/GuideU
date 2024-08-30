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
    func dtoToEntity(_ dto: [CharacterDTO]) -> [CharacterEntity] {
        return dto.map { dtoToEntity($0) }
    }
    
    /// CharactersDTO -> Entity
    func dtoToEntity(_ dto: CharacterDTO) -> CharacterEntity {
        return CharacterEntity(name: dto.name, engName: dto.engName, definition: dto.definition, smallImageUrl: dto.smallImageUrl, largeImageUrl: dto.largeImageUrl, links: dtoToEntity(dto.links ?? []), id: dto.id)
    }
}

extension CharacterMapper {
    
    private func dtoToEntity(_ dto: [LinkDTO]) -> [LinkEntity] {
        return dto.map { dtoToEntity($0) }
    }
    
    private func dtoToEntity(_ dto: LinkDTO) -> LinkEntity {
        return LinkEntity(link: dto.link, title: dto.title, thumbnailURL: dto.thumbnailURL, channel: dto.channel, type: dto.type, description: dto.description, createdAt: dto.createdAt)
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
