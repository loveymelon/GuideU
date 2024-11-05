//
//  CharacterRepository.swift
//  GuideU
//
//  Created by 김진수 on 8/27/24.
//

import Foundation
import ComposableArchitecture

final class CharacterRepository: @unchecked Sendable {
    @Dependency(\.networkManager) var network
    @Dependency(\.characterMapper) var mapper
    @Dependency(\.errorMapper) var errorMapper
}

extension CharacterRepository {
    
    func fetchCharacter(id: Int) async throws -> CharacterEntity {
        let data = try await network.requestNetwork(dto: CharacterDTO.self, router: CharacterRouter.fetchCharacter(id))
        
        return mapper.dtoToEntity(data)
    }
    
    func fetchCharacters(id: String) async throws -> [YoutubeCharacterEntity] {
        let data = try await network.requestNetwork(dto: DTOList<YoutubeCharacterDTO>.self, router: VideoRouter.fetchCharacters(id))
        
        return await mapper.dtoToEntity(data.elements)
    }
    
    func fetchMemes(id: String) async throws -> [BookElementsEntity] {
        let data = try await network.requestNetwork(dto: DTOList<BookElementDTO>.self, router: VideoRouter.fetchMemes(id))
        
        return await mapper.dtoToEntity(data.elements)
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
    static let liveValue: CharacterRepository = CharacterRepository()
}

extension DependencyValues {
    var characterRepository: CharacterRepository {
        get { self[CharacterRepository.self] }
        set { self[CharacterRepository.self] = newValue }
    }
}
