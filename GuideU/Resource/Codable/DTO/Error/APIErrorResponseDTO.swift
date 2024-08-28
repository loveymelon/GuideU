//
//  APIErrorResponseDTO.swift
//  GuideU
//
//  Created by 김진수 on 8/28/24.
//

import Foundation

enum APIErrorResponse: ErrorDTO {
    case simple(SimpleErrorDTO)
    case detailed(DetailedErrorDTO)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        // 첫 번째 케이스: SimpleErrorResponse로 디코딩 시도
        if let simpleResponse = try? container.decode(SimpleErrorDTO.self) {
            self = .simple(simpleResponse)
            return
        }

        // 두 번째 케이스: DetailedErrorResponse로 디코딩 시도
        if let detailedResponse = try? container.decode(DetailedErrorDTO.self) {
            self = .detailed(detailedResponse)
            return
        }

        // 어느 것도 디코딩되지 않은 경우 오류 발생
        throw DecodingError.typeMismatch(APIErrorResponse.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode APIErrorResponse"))
    }
}
