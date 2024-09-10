//
//  CharacterMapper.swift
//  GuideU
//
//  Created by 김진수 on 8/27/24.
//

import Foundation
import ComposableArchitecture

struct CharacterMapper {
    func dtoToEntity(_ dto: [YoutubeCharacterDTO]) -> [YoutubeCharacterEntity] {
        return dto.map { dtoToEntity($0) }
    }
    
    func dtoToEntity(_ dto: [BookElementDTO]) -> [BookElementsEntity] {
        return dto.map { dtoToEntity($0) }
    }
    
    /// CharacterDTO -> Entity
    func dtoToEntity(_ dto: CharacterDTO) -> CharacterEntity {
        return CharacterEntity(name: dto.name, engName: dto.engName, definition: dto.definition, smallImageUrl: URL(string: dto.smallImageUrl), largeImageUrl: URL(string: dto.largeImageUrl), links: dtoToEntity(dto.links ?? []), id: dto.id)
    }

    /// CharactersDTO -> Entity
    func dtoToEntity(_ dto: [CharacterDTO]) -> [CharacterEntity] {
        return dto.map { dtoToEntity($0) }
    }
    
    /// MemeDTO -> MemeEntity
    func dtoToEntity(_ dto: [MemeDTO]) -> [MemeEntity] {
        return dto.map { dtoToEntity($0) }
    }
}

extension CharacterMapper {
    
    private func dtoToEntity(_ dto: YoutubeCharacterDTO) -> YoutubeCharacterEntity {
        return YoutubeCharacterEntity(name: dto.name, engName: dto.engName, definition: dto.definition, smallImageURL: URL(string: dto.smallImageURL), largeImageURL: URL(string: dto.largeImageURL), links: dtoToEntity(dto.links))
    }
    
    private func dtoToEntity(_ dto: BookElementDTO) -> BookElementsEntity {
        return BookElementsEntity(timestamp: intToTime(time: dto.timestamp), memes: dtoToEntity(dto.memes))
    }
    
    private func dtoToEntity(_ dto: [LinkDTO]) -> [LinkEntity] {
        return dto.map { dtoToEntity($0) }
    }
    
    private func dtoToEntity(_ dto: LinkDTO) -> LinkEntity {
        return LinkEntity(link: dto.link, title: dto.title, thumbnailURL: dto.thumbnailURL, channel: dto.channel, type: dto.type, description: dto.description, createdAt: dto.createdAt)
    }
    
    /// MemeDTO -> MemeEntity
    private func dtoToEntity(_ dto: MemeDTO) -> MemeEntity {
        return MemeEntity(name: dto.name, definition: dto.definition, description: dto.description, synonyms: dto.synonyms, relatedVideos: dtoToEntity(dto.relatedVideos), isDetectable: dto.isDetectable, id: dto.id, duplicates: dtoToEntity(dto.duplicates ?? []), appearanceTime: dto.appearanceTime ?? 0)
    }
    
    /// [RelatedVideoDTO] -> [RelatedVideoEntity]
    private func dtoToEntity(_ dto: [RelatedVideoDTO]) -> [RelatedVideoEntity] {
        return dto.map { dtoToEntity($0) }
    }
    
    /// RelatedVideoDTO -> RelatedVideoEntity
    private func dtoToEntity(_ dto: RelatedVideoDTO) -> RelatedVideoEntity {
        return RelatedVideoEntity(link: dto.link, title: dto.title, thumbnailURL: URL(string: dto.thumbnailURL), channel: dto.channel, type: dto.type)
    }
    
    /// [DuplicateDTO] -> [DuplicateEntity]
    private func dtoToEntity(_ dto: [DuplicateDTO]) -> [DuplicateEntity] {
        return dto.map { dtoToEntity($0) }
    }
    
    /// DuplicateDTO -> DuplicateEntity
    private func dtoToEntity(_ dto: DuplicateDTO) -> DuplicateEntity {
        return DuplicateEntity(name: dto.name, memeID: dto.memeID)
    }
    
    private func intToTime(time: Int) -> String {
        let min = time / 60
        let sec = time % 60
        
        return String(format: "%02d:%02d", min, sec)
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
