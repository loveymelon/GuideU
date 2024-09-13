//
//  NWPathMonitorManager.swift
//  GuideU
//
//  Created by 김진수 on 9/13/24.
//

import Foundation
import Network
import Combine
import ComposableArchitecture

final class NWPathMonitorManager {
    
    static let shared = NWPathMonitorManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    let currentConnectionType = PassthroughSubject<ConnectionType, Never>()
    let currentConnectionTrigger = CurrentValueSubject<Bool, Never> (true)
    
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
    
    func stop() {
        monitor.cancel()
        print(#function)
    }
    
}

extension NWPathMonitorManager {
    private func startMonitoring() {
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else {
                print("Lost self: \(self.debugDescription)")
                return
            }
            updateHandler(path: path)
        }
    }
    
    private func updateHandler(path: NWPath) {
        getConnectionType(path: path)
        networkConnectStatus(path: path)
        #if DEBUG
        print(#function)
        print(path.status)
        #endif
    }
    
    private func getConnectionType(path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            currentConnectionType.send(.wifi)
        } else if path.usesInterfaceType(.cellular) {
            currentConnectionType.send(.cellular)
        } else if path.usesInterfaceType(.wiredEthernet) {
            currentConnectionType.send(.ethernet)
        } else {
            currentConnectionType.send(.unknown)
        }
    }
    
    private func networkConnectStatus(path: NWPath) {
        currentConnectionTrigger.send(path.status == .satisfied)
    }
}

extension NWPathMonitorManager: DependencyKey {
    static var liveValue: NWPathMonitorManager = NWPathMonitorManager.shared
}

extension DependencyValues {
    var nwPathMonitorManager: NWPathMonitorManager {
        get { self[NWPathMonitorManager.self] }
        set { self[NWPathMonitorManager.self] = newValue }
    }
}
