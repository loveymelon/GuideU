//
//  NetworkInterceptor.swift
//  GuideU
//
//  Created by 김진수 on 8/26/24.
//

import Foundation
import Alamofire

final class NetworkInterceptor: RequestInterceptor {
    
    private var retryLimit = 3
    private var retryRequests: [(RetryResult) -> Void] = []
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        retryLimit -= 1
        
        if retryLimit >= 0 {
            completion(.retryWithDelay(1))
        } else {
            completion(.doNotRetry)
        }
    }
}
