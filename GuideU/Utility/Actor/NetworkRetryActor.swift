//
//  NetworkRetryActor.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/8/24.
//

import Foundation

final actor RetryCountActor {
    
    private var retryLimit: Int
    
    init(retryLimit: Int = 3) {
        self.retryLimit = retryLimit
    }
    
    func retry() {
        retryLimit -= 1
    }
    
    func reset() {
        retryLimit = 7
    }
    
    func ifRetry() -> Bool {
        return retryLimit > 0
    }
}
