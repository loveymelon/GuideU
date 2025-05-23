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

final class NetworkManager: Sendable, ThreadCheckable {
    
    private let networkError = PassthroughSubject<String, Never>()
    
    private let cancelStoreActor = AnyValueActor(Set<AnyCancellable>())
    private let retryActor = AnyValueActor(7)
   
    func requestNetwork<T: DTO, R: Router>(dto: T.Type, router: R) async throws(NetworkAPIError) -> T {
        #if DEBUG
        checkedMainThread() // 현재 쓰레드 확인
        #endif
            do {
                let request = try router.asURLRequest()
                
                // MARK: 요청담당
                let response = await getRequest(dto: dto, router: router, request: request)
                
                let result = try await getResponse(dto: dto, router: router, response: response)
                
                return result
            } catch let routerError as RouterError {
                throw .routerError(routerError)
            } catch let apiError as APIErrorResponse {
                switch apiError {
                case .simple(let simpleErrorDTO):
                    throw .viewError(.msg(simpleErrorDTO.detail))
                case .detailed(let detailedErrorDTO):
                    #if DEBUG
                    print("detail")
                    #endif
                    dump(detailedErrorDTO)
                    throw .viewError(.msg(detailedErrorDTO.detail.first?.msg ?? "unknown"))
                }
            } catch {
                #if DEBUG
                print("emergency")
                #endif
                throw .viewError(.msg("unknown"))
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
    private func getResponse<T:DTO>(dto: T.Type, router: Router, response: DataResponse<T, AFError>) async throws(APIErrorResponse) -> T {
        switch response.result {
        case let .success(data):
            await retryActor.resetValue()
            
            return data
        case let .failure(guideError):
            #if DEBUG
            print(guideError)
            #endif
            do {
                let retryResult = try await retryNetwork(dto: dto, router: router)
                
                // 성공시 초기화
                await retryActor.resetValue()
                
                return retryResult
            } catch {
                throw checkResponseData(response.data, guideError)
            }
        }
    }

    private func retryNetwork<T: DTO, R: Router>(dto: T.Type, router: R) async throws(APIErrorResponse) -> T {
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
                throw APIErrorResponse.simple(SimpleErrorDTO(detail: "retry count over"))
            }
        } catch {
            throw APIErrorResponse.simple(SimpleErrorDTO(detail: "retry count over"))
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
