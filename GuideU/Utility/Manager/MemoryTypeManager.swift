//
//  MemoryTypeManager.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/23/24.
//

import Foundation

struct MemoryTypeManager {
    
    enum MemoryType {
        case mb(Int)
//        case gb
    }
    
    func memoryTypeChange(memoryType: MemoryType) -> Int {
        switch memoryType {
        case let .mb(type):
            return type * 1024 * 1024
        }
    }
}
