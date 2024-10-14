//
//  CustomIsolated.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/9/24.
//

import Foundation

final class LockIsolated<Value>: @unchecked Sendable {
    
    private var value: Value
    private let lock = NSRecursiveLock()
    
    init(_ value: @autoclosure @Sendable () throws -> Value) rethrows {
        self.value = try value() // Try 해야 하는 벨류도 받기위한 오토 클로저
    }
    
    subscript<Subject: Sendable>(dynamicMember keyPath: KeyPath<Value, Subject>) -> Subject {
        self.lock.sync {
            self.value[keyPath: keyPath]
        }
    }
    
    func withValue<T: Sendable>(
        _ operation: @Sendable (inout Value) throws -> T
    ) rethrows -> T {
        try self.lock.sync {
            var value = self.value
            defer { self.value = value }
            return try operation(&value)
        }
    }
    
    func setValue(_ newValue: @autoclosure @Sendable () throws -> Value) rethrows {
        try self.lock.sync {
            self.value = try newValue()
        }
    }
}

extension LockIsolated where Value: Sendable {
    /// The lock-isolated value.
    var value: Value {
        self.lock.sync {
            self.value
        }
        
    }
}

extension NSRecursiveLock {
    @discardableResult
    func sync<R>(work: () throws -> R) rethrows -> R {
        self.lock()
        defer { self.unlock() }
        return try work()
    }
}
