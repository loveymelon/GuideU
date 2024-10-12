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
    
    private let networkError = PassthroughSubject<String, Never>()
    
    private let cancelStoreActor = AnyValueActor(Set<AnyCancellable>())
    private let retryActor = AnyValueActor(7)
   
    func requestNetwork<T: DTO, R: Router>(dto: T.Type, router: R) async -> Result<T, APIErrorResponse> {
            do {
                let request = try router.asURLRequest()
                
                // MARK: 요청담당
                let response = await getRequest(dto: dto, router: router, request: request)
                
                let result = await getResponse(dto: dto, router: router, response: response)
                
                return result
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
              
                await cancelStoreActor.withValue { value in
                    value.insert(subscribe)
                }
            }
            
            contin.onTermination = { @Sendable [weak self] _ in
                guard let self else { return }
                Task {
                    await cancelStoreActor.resetValue()
                }
            }
        }
    }
}

extension NetworkManager {
    // MARK: 요청담당
    private func getRequest<T: DTO, R: Router>(dto: T.Type, router: R, request: URLRequest) async -> DataResponse<T, AFError> {
        return await AF.request(request)
            .cacheResponse(using: .cache)
            .validate(statusCode: 200..<300)
            .serializingDecodable(T.self)
            .response
    }
    
    // MARK: RE스폰스 담당
    private func getResponse<T:DTO>(dto: T.Type, router: Router, response: DataResponse<T, AFError>) async -> Result<T,APIErrorResponse> {
        switch response.result {
        case let .success(data):
            await retryActor.resetValue()
            
            return .success(data)
        case let .failure(guideError):
            print(guideError)
            do {
                let retryResult = try await retryNetwork(dto: dto, router: router)
                
                // 성공시 초기화
                await retryActor.resetValue()
                
                return .success(retryResult)
            } catch {
                return .failure(checkResponseData(response.data, guideError))
            }
        }
    }

    private func retryNetwork<T: DTO, R: Router>(dto: T.Type, router: R) async throws -> T {
        let ifRetry = await retryActor.withValue { value in
            return value > 0
        }
        
        do {
            if ifRetry {
                let response = try await getRequest(dto: dto, router: router, request: router.asURLRequest())
                
                switch response.result {
                case let .success(data):
                    return data
                case .failure(_):
                    await downRetryCount()
                    
                    return try await retryNetwork(dto: dto, router: router)
                }
            } else {
                throw NSError()
            }
        } catch {
            throw NSError()
        }
    }
    
    private func downRetryCount() async {
        await retryActor.withValue { value in
            value -= 1
        }
    }
    
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
