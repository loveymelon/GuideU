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
    func fetchCharacter(limit: Int = 100, offset: Int = 0, start: String = "0") async -> Result<CharacterEntity, DetailErrorEntity> {
        let result = await network.requestNetwork(dto: CharactersDTO.self, router: CharacterRouter.fetchCharacterList(limit: limit, offset: offset, start: start), errorDTO: DetailErrorDTO.self)
        
        switch result {
        case .success(let data):
            return .success(mapper.dtoToEntity(data))
        case .failure(let error):
            return .failure(errorMapper.dtoToEntity(error))
        }
        
    }
}
