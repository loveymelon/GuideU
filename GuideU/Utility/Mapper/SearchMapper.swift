//
//  SearchMapper.swift
//  GuideU
//
//  Created by 김진수 on 9/2/24.
//

import Foundation
import ComposableArchitecture

struct SearchMapper: Sendable {
    
    /// [SuggestDTO] -> [Entity]
    func dtoToEntity(_ dtos: [SuggestDTO]) -> [SuggestEntity] {
        return dtos.map { dtoToEntity($0) }
    }
    
    func dtoToEntity(_ dtos: [SearchDTO]) -> [SearchResultEntity] {
        return dtos.map { dtoToEntity($0) } 
    }
    
    func dtoToEntity(_ dtos: [SearchDTO]) -> [SearchResultListEntity] {
        return dtos.map { dtoToEntity($0) }
    }
    
    func searchResultToSuggest(_ searchResult: SearchResultListEntity) -> SuggestEntity {
        return SuggestEntity(type: searchResult.type, keyWord: searchResult.name)
    }
    
    /// SuggestEntity -> SearchHistoryRequestDTO
    func entityToRequestDTO(_ entity: SuggestEntity) -> SearchHistoryRequestDTO {
        return SearchHistoryRequestDTO(history: entity.keyWord, date: Date())
    }
    
    /// [SearchHistoryRequestDTO] -> [String]
    func requestDTOToString(_ request: [SearchHistoryRequestDTO]) -> [String] {
        return request.map { requestDTOToString($0) }
    }
}

extension SearchMapper {
    private func dtoToEntity(_ dto: SearchDTO) -> SearchResultEntity {
        return SearchResultEntity(name: dto.name, resultType: ResultCase(rawValue: dto.type.rawValue) ?? .character, mean: dto.definition, description: dto.description ?? "", relatedVideos: dto.relatedVideos?.compactMap{ dtoToEntity($0) } ?? [], links: dtoToEntity(dto.links ?? []))
    }
    
    /// SuggestDTO -> SuggestEntity
    private func dtoToEntity(_ dto: SuggestDTO) -> SuggestEntity {
        return SuggestEntity(type: ResultCase(rawValue: dto.type) ?? .character, keyWord: dto.keyword)
    }
    
    /// SearchHistoryRequestDTO -> String
    private func requestDTOToString(_ request: SearchHistoryRequestDTO) -> String {
        return request.history
    }
    
    private func dtoToEntity(_ dto: RelatedVideoDTO) -> RelatedVideoEntity {
        return RelatedVideoEntity(link: dto.link, title: dto.title ?? "", thumbnailURL: URL(string: dto.thumbnailURL ?? ""), channel: dto.channel ?? "", type: dto.type ?? .afreeca)
    }
    
    private func dtoToEntity(_ dto: [LinkDTO]) -> [LinkEntity] {
        return dto.map { dtoToEntity($0) }
    }
    
    private func dtoToEntity(_ dto: LinkDTO) -> LinkEntity {
        return LinkEntity(link: dto.link, title: dto.title, thumbnailURL: dto.thumbnailURL, channel: dto.channel, type: dto.type, description: dto.description, createdAt: dto.createdAt)
    }
    
    /// SearchDTO -> SearchResultListEntity
    private func dtoToEntity(_ dto: SearchDTO) -> SearchResultListEntity {
        return SearchResultListEntity(name: dto.name, type: ResultCase(rawValue: dto.type.rawValue) ?? .meme, definition: dto.definition)
    }
}

extension SearchMapper: DependencyKey {
    static let liveValue = Self()
}

extension DependencyValues {
    var searchMapper: SearchMapper {
        get { self[SearchMapper.self] }
        set { self[SearchMapper.self] = newValue }
    }
}
