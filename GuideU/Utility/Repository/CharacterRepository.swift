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
            return .success(mapper.dtoToEntity(data.CharactersDTO))
        case .failure(let error):
            switch error {
                
            case let .simple(simpleError):
                return .failure(errorMapper.dtoToEntity(simpleError))
            case let .detailed(detailError):
                return .failure(errorMapper.dtoToEntity(detailError))
            }
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
