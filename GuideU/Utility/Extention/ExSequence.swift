//
//  ExSequence.swift
//  GuideU
//
//  Created by Jae hyung Kim on 11/5/24.
//

import Foundation

extension Sequence {
    func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        var values: [T] = []
        for element in self {
            try await values.append(transform(element))
        }
        return values
    }
}
