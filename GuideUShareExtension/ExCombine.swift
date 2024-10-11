//
//  ExCombine.swift
//  GuideUShareExtension
//
//  Created by Jae hyung Kim on 10/11/24.
//

import Combine
import Foundation

// MARK: sink -> TaskSink
extension Publisher where Failure == Never {
    
    func sinkTask(receiveValue: @escaping (Self.Output) async throws -> Void) -> AnyCancellable {
        sink { value in // 타
            Task { // 타타 YES 맞네 최상단은 이놈이니까 다르다 이거구만.
                try await receiveValue(value)
            }
        }
    }
}

extension Publisher {
    
    // MARK: [weak self] Streaming
    func guardSelf<ob: AnyObject>(
        _ object: ob
    ) -> Publishers.CompactMap
    <Self, (ob,Self.Output)> {
        
        return compactMap { [weak object] output in
            guard let object else {
                return nil
            }
            return (object, output)
        }
    }
    
    // MARK: [unownedSelf] Streaming
    func guardUnownedSelf<ob: AnyObject> (
        _ object: ob
    ) -> Publishers.Map
    <Self, (ob,Self.Output)> {
        
        return map { [unowned object] output in
            return ( object, output )
        }
    }
}
