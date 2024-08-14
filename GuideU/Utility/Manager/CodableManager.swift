//
//  CodableManager.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import Foundation

final class CodableManager {
    
    static let shared = CodableManager()
    
    private init () {}
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    
}

extension CodableManager {
    
    func jsonEncoding<T: Encodable>(from value: T) throws -> Data {
        return try encoder.encode(value)
    }
    
    func jsonDecoding<T:Decodable>(model: T.Type, from data: Data) throws -> T {
        return try decoder.decode(T.self, from: data)
    }
}



