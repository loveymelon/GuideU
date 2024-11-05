//
//  SearchRepository.swift
//  GuideU
//
//  Created by 김진수 on 9/2/24.
//

import Foundation
import ComposableArchitecture

final class SearchRepository: @unchecked Sendable {
    @Dependency(\.networkManager) var network
    @Dependency(\.searchMapper) var searchMapper
    @Dependency(\.errorMapper) var errorMapper
    
    func fetchSuggest(_ searchText: String) async throws -> [SuggestEntity] {
        let data = try await network.requestNetwork(dto: DTOList<SuggestDTO>.self, router: SearchRouter.suggest(searchText: searchText))
        
        return await searchMapper.dtoToEntity(data.elements)
    }
    
    func fetchSearch(_ suggestEntity: SuggestEntity) async throws -> [SearchResultEntity] {
        let data = try await network.requestNetwork(dto: DTOList<SearchDTO>.self, router: SearchRouter.search(title: suggestEntity.keyWord, type: suggestEntity.type))
        
        return await searchMapper.dtoToEntity(data.elements)
    }
    
    func fetchSearchResults(_ text: String) async throws -> [SearchResultEntity] {
        let data = try await network.requestNetwork(dto: DTOList<SearchDTO>.self, router: SearchRouter.search(title: text, type: nil))
        
        return await searchMapper.dtoToEntity(data.elements)
    }
}

extension SearchRepository {
    private func catchError(_ error: APIErrorResponse) -> String {
        switch error {
            
        case let .simple(simpleError):
            return errorMapper.dtoToEntity(simpleError)
        case let .detailed(detailError):
            return errorMapper.dtoToEntity(detailError)
        }
    }
}

extension SearchRepository: DependencyKey {
    static let liveValue: SearchRepository = SearchRepository()
}

extension DependencyValues {
    var searchRepository: SearchRepository {
        get { self[SearchRepository.self] }
        set { self[SearchRepository.self] = newValue }
    }
}
