//
//  ErrorMapper.swift
//  GuideU
//
//  Created by 김진수 on 8/27/24.
//

import Foundation
import ComposableArchitecture

struct ErrorMapper {
    /// SimpleErrorDTO -> Entity
    func dtoToEntity(_ dto: SimpleErrorDTO) -> String {
        return SimpleErrorEntity(detail: dto.detail).detail
    }
    
    /// DetailedErrorDTO -> Entity
    func dtoToEntity(_ dto: DetailedErrorDTO) -> String {
        return DetailedErrorEntity(detail: dto.detail.map { dtoToEntity($0) }).detail.first?.message ?? "empty"
    }
}

extension ErrorMapper {
    /// DetailErrorDTO -> Entity
    private func dtoToEntity(_ dto: DetailErrorDTO) -> DetailErrorEntity {
        return DetailErrorEntity(message: dto.msg, type: dto.type)
    }
}

extension ErrorMapper: DependencyKey {
    static let liveValue: ErrorMapper = ErrorMapper()
}

extension DependencyValues {
    var errorMapper: ErrorMapper {
        get { self[ErrorMapper.self] }
        set { self[ErrorMapper.self] = newValue }
    }
}
