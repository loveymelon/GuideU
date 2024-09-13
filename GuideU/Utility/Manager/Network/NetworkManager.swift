//
//  NetworkManager.swift
//  GuideU
//
//  Created by 김진수 on 8/26/24.
//

import Alamofire
import ComposableArchitecture
import Foundation
import Combine

final class NetworkManager {
    
    typealias ResultContinuation<T: DTO> = CheckedContinuation<Result<T, APIErrorResponse>, Never>
    
    let networkError = PassthroughSubject<String, Never>()
    
    func requestNetwork<T: DTO, R: Router>(dto: T.Type, router: R) async -> Result<T, APIErrorResponse> {
        
        return await withCheckedContinuation { [weak self] continuation in
            
            guard let weakSelf = self else {
                let defaultErrorResponse = APIErrorResponse.simple(SimpleErrorDTO(detail: "unknown"))
                continuation.resume(returning: .failure(defaultErrorResponse))
                return
            }
            
            do {
                let request = try router.asURLRequest()
                print ("Reqeust : ", request)
                AF.request(request, interceptor: NetworkInterceptor())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case let .success(data):
                            continuation.resume(returning: .success(data))
                        case let .failure(error):
                            continuation.resume(returning: .failure(weakSelf.checkResponseData(response.data, error)))
                        }
                        
                    }
                
            } catch {
                continuation.resume(returning: .failure(weakSelf.catchUnknownError()))
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
    static var liveValue: NetworkManager = NetworkManager()
}

extension DependencyValues {
    var networkManager: NetworkManager {
        get { self[NetworkManager.self] }
        set { self[NetworkManager.self] = newValue }
    }
}
