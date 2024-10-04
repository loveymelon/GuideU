//
//  CancellableStore.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/4/24.
//

import Combine

final actor CancellableStore {
    private var cancellables: [AnyCancellable] = []
    
    func append(_ cancellable: AnyCancellable) {
        cancellables.append(cancellable)
    }
    
    func removeAll() {
        cancellables = []
    }
}
