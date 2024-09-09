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
    
    func fetchCharacter(id: Int) async -> Result<CharacterEntity, String> {
        let result = await network.requestNetwork(dto: CharacterDTO.self, router: CharacterRouter.fetchCharacter(id))
        
        switch result {
        case .success(let data):
            return .success(mapper.dtoToEntity(data))
        case .failure(let error):
            return .failure(catchError(error))
        }
    }
    
    func fetchCharacters(id: String) async -> Result<[YoutubeCharacterEntity], String> {
        let result = await network.requestNetwork(dto: YoutubeCharactersDTO.self, router: VideoRouter.fetchCharacters(id))
        
        switch result {
        case .success(let data):
            return .success(mapper.dtoToEntity(data.charactersDTO))
        case .failure(let error):
            return .failure(catchError(error))
        }
    }
    
    func fetchMemes(id: String) async -> Result<[MemeEntity], String> {
        let result = await network.requestNetwork(dto: BooksDTO.self, router: VideoRouter.fetchMemes(id))
        
        switch result {
        case .success(let data):
            return .success(mapper.dtoToEntity(data.bookListDTO))
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
