//
//  NetworkManager.swift
//  GuideU
//
//  Created by 김진수 on 8/26/24.
//

import Alamofire
import ComposableArchitecture

final class NetworkManager {
    
    func requestNetwork<T: DTO, R: Router, E: ErrorDTO>(dto: T.Type, router: R, errorDTO: E.Type) async -> Result<T, E> {
        
        return await withCheckedContinuation { continuation in
            
            do {
                let request = try router.asURLRequest()
                
                AF.request(request, interceptor: NetworkInterceptor())
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case let .success(data):
                            continuation.resume(returning: .success(data))
                        case .failure(_):
                            guard let data = response.data else {
                                print("error")
                                return
                            }
                            do {
                                let errorData = try CodableManager.shared.jsonDecoding(model: errorDTO, from: data)
                                
                                continuation.resume(returning: .failure(errorData))
                            } catch {
                                print(error)
                            }
                        }
                        
                    }
                
            } catch {
                print(error)
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
