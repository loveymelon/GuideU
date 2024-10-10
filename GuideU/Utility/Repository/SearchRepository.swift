//
//  SearchRepository.swift
//  GuideU
//
//  Created by 김진수 on 9/2/24.
//

import Foundation
import ComposableArchitecture

struct SearchRepository {
    @Dependency(\.networkManager) var network
    @Dependency(\.searchMapper) var searchMapper
    @Dependency(\.errorMapper) var errorMapper
    
    func fetchSuggest(_ searchText: String) async -> Result<[SuggestEntity], String> {
        let result = await network.requestNetwork(dto: DTOList<SuggestDTO>.self, router: SearchRouter.suggest(searchText: searchText))
        
        switch result {
        case .success(let data):
            return .success(searchMapper.dtoToEntity(data.elements))
        case .failure(let error):
            return .failure(catchError(error))
        }
    }
    
    func fetchSearch(_ suggestEntity: SuggestEntity) async -> Result<[SearchResultEntity], String> {
        let result = await network.requestNetwork(dto: DTOList<SearchDTO>.self, router: SearchRouter.search(title: suggestEntity.keyWord, type: suggestEntity.type))
        
        switch result {
        case .success(let data):
            return .success(searchMapper.dtoToEntity(data.elements))
        case .failure(let error):
            return .failure(catchError(error)) 
        }
    }
    
    func fetchSearchResults(_ text: String) async -> Result<[SearchResultEntity], String> {
        let result = await network.requestNetwork(dto: DTOList<SearchDTO>.self, router: SearchRouter.search(title: text, type: nil))
        
        switch result {
        case .success(let data):
            return .success(searchMapper.dtoToEntity(data.elements))
        case .failure(let error):
            return .failure(catchError(error))
        }
    }
    
//    func fetchSearch(_ searchResultList: SearchResultListEntity) async -> Result<[SearchResultEntity], String> {
//        let result = await network.requestNetwork(dto: DTOList<SearchDTO>.self, router: SearchRouter.search(title: searchResultList.name, type: searchResultList.type))
//        
//        switch result {
//        case .success(let data):
//            return .success(searchMapper.dtoToEntity(data.elements))
//        case .failure(let error):
//            return .failure(catchError(error))
//        }
//    }
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
