//
//  CharacterRepository.swift
//  GuideU
//
//  Created by 김진수 on 8/27/24.
//

import Foundation
import ComposableArchitecture

final class CharacterRepository {
    @Dependency(\.networkManager) var network
    @Dependency(\.characterMapper) var mapper
    @Dependency(\.errorMapper) var errorMapper
}

extension CharacterRepository {
    func fetchCharacter(limit: Int = 1, offset: Int = 0, start: String? = nil) async -> Result<[CharacterEntity], String> {
        let result = await network.requestNetwork(dto: CharactersDTO.self, router: CharacterRouter.fetchCharacterList(limit: limit, offset: offset, start: start))
        
        switch result {
        case .success(let data):
            return .success(mapper.dtoToEntity(data.charactersDTO))
        case .failure(let error):
            return .failure(catchError(error))
        }
    }
    
    
    
    func fetchSearch(_ searchText: String) async -> Result<[SearchDTO], String> {
        let result = await network.requestNetwork(dto: SearchListDTO.self, router: SearchRouter.search(searchText: searchText))
        
        switch result {
        case .success(let data):
            return .success(data.searchListDTO)
        case .failure(let error):
            return .failure(catchError(error))
        }
    }
}

extension CharacterRepository {
    private func catchError(_ error: APIErrorResponse) -> String {
        switch error {
            
        case let .simple(simpleError):
            return errorMapper.dtoToEntity(simpleError)
        case let .detailed(detailError):
            return errorMapper.dtoToEntity(detailError)
        }
    }
}

extension CharacterRepository: DependencyKey {
    static var liveValue: CharacterRepository = CharacterRepository()
}

extension DependencyValues {
    var characterRepository: CharacterRepository {
        get { self[CharacterRepository.self] }
        set { self[CharacterRepository.self] = newValue }
    }
}
