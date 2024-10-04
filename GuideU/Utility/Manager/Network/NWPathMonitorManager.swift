//
//  NWPathMonitorManager.swift
//  GuideU
//
//  Created by 김진수 on 9/13/24.
//

import Foundation
import Network
@preconcurrency import Combine
import ComposableArchitecture

final class NWPathMonitorManager: Sendable {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkManager")
    private let connectionTypeSubject = PassthroughSubject<ConnectionType, Never>()
    private let currentConnectionTrigger = CurrentValueSubject<Bool, Never> (true)
    
    enum ConnectionType {
        case cellular
        case ethernet
        case wifi
        case unknown
    }
    
    private init() {}
    
    func start() {
        startMonitoring()
        print(#function)
    }
    
    func getToConnectionType() -> AnyPublisher<ConnectionType, Never> {
        return connectionTypeSubject.eraseToAnyPublisher()
    }
    
    func getToConnectionTrigger() -> AsyncStream<Bool> {
        return AsyncStream { [weak self] continuation in
            guard let self else { return }
            
            monitor.pathUpdateHandler = { path in
                Task {
                    let trigger = self.networkConnectStatus(path: path)
                    print(trigger)
                    continuation.yield(trigger)
                }
            }
        }
    }
    
    func stop() {
        monitor.cancel()
        print(#function)
    }
    
}

extension NWPathMonitorManager {
    
    private func startMonitoring() {
        monitor.start(queue: queue)
    }
    
    private func updateHandler(path: NWPath) {
        getConnectionType(path: path)
        #if DEBUG
        print(#function)
        print(path.status)
        #endif
    }

    
    private func getConnectionType(path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionTypeSubject.send(.wifi)
        } else if path.usesInterfaceType(.cellular) {
            connectionTypeSubject.send(.cellular)
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionTypeSubject.send(.ethernet)
        } else {
            connectionTypeSubject.send(.unknown)
        }
    }
    
    private func networkConnectStatus(path: NWPath) -> Bool {
        return path.status == .satisfied
    }
}


extension NWPathMonitorManager: DependencyKey {
    static let liveValue: NWPathMonitorManager = NWPathMonitorManager()
}

extension DependencyValues {
    var nwPathMonitorManager: NWPathMonitorManager {
        get { self[NWPathMonitorManager.self] }
        set { self[NWPathMonitorManager.self] = newValue }
    }
}
