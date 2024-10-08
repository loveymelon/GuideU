//
//  NetworkRetryActor.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/8/24.
//

import Foundation

final actor RetryCountActor {
    
    private var retryLimit = 7
    
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
