//
//  NetworkManager.swift
//  GuideU
//
//  Created by 김진수 on 8/26/24.
//

import Alamofire
import ComposableArchitecture
import Foundation
@preconcurrency import Combine

final class NetworkManager: Sendable {
    
    typealias ResultContinuation<T: DTO> = CheckedContinuation<Result<T, APIErrorResponse>, Never>
    
    private let networkError = PassthroughSubject<String, Never>()
    
    private let store = CancellableStore()
    
    func requestNetwork<T: DTO, R: Router>(dto: T.Type, router: R) async -> Result<T, APIErrorResponse> {
        
        do {
            let request = try router.asURLRequest()
            
            let response = await AF.request(request, interceptor: NetworkInterceptor())
                .cacheResponse(using: .cache)
                .validate(statusCode: 200..<300)
                .serializingDecodable(T.self)
                .response
            
            switch response.result {
            case let .success(data):
                return .success(data)
            case let .failure(error):
                return .failure(checkResponseData(response.data, error))
            }
            
        } catch {
            return .failure(catchUnknownError())
        }
    }
    
    func getNetworkError() -> AsyncStream<String> {
        
        return AsyncStream<String> { contin in
            Task {
                let subscribe = networkError
                    .sink { text in
                        contin.yield(text)
                    }
                await store.append(subscribe)
            }
            
            contin.onTermination = { @Sendable [weak self] _ in
                Task {
                    await self?.store.removeAll()
                }
            }
        }
    }
}

extension NetworkManager {
    private func checkResponseData(_ responseData: Data?, _ error: AFError) -> APIErrorResponse {
        if let data = responseData {
            do {
                let errorResponse = try CodableManager.shared.jsonDecoding(model: APIErrorResponse.self, from: data)
                return errorResponse
            } catch {

                let defaultErrorResponse = APIErrorResponse.simple(SimpleErrorDTO(detail: "unknown"))
                
                return defaultErrorResponse
            }
        } else {
            return catchURLError(error)
        }
    }
    
    private func catchURLError(_ error: AFError) -> APIErrorResponse {
        if let afError = error.asAFError, let urlError = afError.underlyingError as? URLError {
            switch urlError.code {
            case .timedOut:
                let errorResponse = APIErrorResponse.simple(SimpleErrorDTO(detail: "요청 시간이 초과되었습니다."))
                networkError.send("요청 시간이 초과되었습니다.")
                return errorResponse
                
            default:
                return catchUnknownError()
            }
        } else {
            return catchUnknownError()
        }
    }
    
    private func catchUnknownError() -> APIErrorResponse {
        APIErrorResponse.simple(SimpleErrorDTO(detail: "unknown"))
    }
}

extension NetworkManager: DependencyKey {
    static let liveValue: NetworkManager = NetworkManager()
}

extension DependencyValues {
    var networkManager: NetworkManager {
        get { self[NetworkManager.self] }
        set { self[NetworkManager.self] = newValue }
    }
}
