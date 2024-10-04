//
//  CancellableStore.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/4/24.
//

import Combine

final actor CancellableStore {
    private var cancellables: Set<AnyCancellable> = []
    
    func append(_ cancellable: AnyCancellable) {
        cancellables.insert(cancellable)
    }
    
    func removeAll() {
        cancellables = []
    }
}
