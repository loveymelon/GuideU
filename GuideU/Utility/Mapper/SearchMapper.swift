//
//  SearchMapper.swift
//  GuideU
//
//  Created by 김진수 on 9/2/24.
//

import Foundation
import ComposableArchitecture

struct SearchMapper {
    
    /// [SuggestDTO] -> [Entity]
    func dtoToEntity(_ dtos: [SuggestDTO]) -> [SuggestEntity] {
        return dtos.map { dtoToEntity($0) }
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
    /// SuggestDTO -> SuggestEntity
    private func dtoToEntity(_ dto: SuggestDTO) -> SuggestEntity {
        return SuggestEntity(type: ResultCase(rawValue: dto.type) ?? .character, keyWord: dto.keyword)
    }
    
    /// SearchHistoryRequestDTO -> String
    private func requestDTOToString(_ request: SearchHistoryRequestDTO) -> String {
        return request.history
    }
}

extension SearchMapper: DependencyKey {
    static var liveValue: SearchMapper = SearchMapper()
}

extension DependencyValues {
    var searchMapper: SearchMapper {
        get { self[SearchMapper.self] }
        set { self[SearchMapper.self] = newValue }
    }
}
