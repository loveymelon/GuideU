//
//  ErrorMapper.swift
//  GuideU
//
//  Created by 김진수 on 8/27/24.
//

import Foundation
import ComposableArchitecture

struct ErrorMapper {
    /// DetailErrorDTO -> Entity
    func dtoToEntity(_ dto: DetailErrorDTO) -> DetailErrorEntity {
        return DetailErrorEntity(message: dto.msg, type: dto.type)
    }
}

extension ErrorMapper: DependencyKey {
    static var liveValue: ErrorMapper = ErrorMapper()
}

extension DependencyValues {
    var errorMapper: ErrorMapper {
        get { self[ErrorMapper.self] }
        set { self[ErrorMapper.self] = newValue }
    }
}
