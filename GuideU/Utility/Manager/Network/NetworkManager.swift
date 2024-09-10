//
//  NetworkManager.swift
//  GuideU
//
//  Created by 김진수 on 8/26/24.
//

import Alamofire
import ComposableArchitecture

final class NetworkManager {
    
    func requestNetwork<T: DTO, R: Router>(dto: T.Type, router: R) async -> Result<T, APIErrorResponse> {
        
        return await withCheckedContinuation { continuation in
            
            do {
                let request = try router.asURLRequest()
                print ("Reqeust : ", request)
                AF.request(request/*, interceptor: NetworkInterceptor()*/)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case let .success(data):
                            continuation.resume(returning: .success(data))
                        case .failure(_):
                            guard let data = response.data else {
                                print("error")
                                return
                            }
                            
                            print("error", String(data: data, encoding: .utf8))
                            
                            do {
                                let apiErrorResponse = try CodableManager.shared.jsonDecoding(model: APIErrorResponse.self, from: data)
                                
                                continuation.resume(returning: .failure(apiErrorResponse))
                            } catch {

                                let defaultErrorResponse = APIErrorResponse.simple(SimpleErrorDTO(detail: "An unknown error occurred"))
                                
                                continuation.resume(returning: .failure(defaultErrorResponse))
                            }
                        }
                        
                    }
                
            } catch {
                print("catchError", error)
            }
            
        }
        
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
