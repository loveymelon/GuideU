//
//  Router.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/14/24.
//

import Foundation
import Alamofire

protocol Router {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var path: String { get }
//    var defaultHeader: HTTPHeaders { get }
    var optionalHeaders: HTTPHeaders? { get } // secretHeader 말고도 추가적인 헤더가 필요시
    var headers: HTTPHeaders { get } // 다 합쳐진 헤더
    var parameters: Parameters? { get }
    var body: Data? { get }
    var encodingType: EncodingType { get }
}

extension Router {
    
    var baseURL: String {
        return GuideUURL.baseURLString
    }
    
//    var defaultHeader: HTTPHeaders {
//        return [HeaderType.secretHeader : APIKey.secretKey]
//    }
    
    var headers: HTTPHeaders {
        var combine = HTTPHeaders()
        if let optionalHeaders {
            optionalHeaders.forEach { header in
                combine.add(header)
            }
        }
        return combine
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var urlRequest = try URLRequest(url: url.appending(path: path), method: method, headers: headers)
        
        switch encodingType {
        case .url:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            return urlRequest
        case .json:
            let jsonObject = CodableManager.shared.toJSONSerialization(data: body)
            urlRequest = try JSONEncoding.default.encode(urlRequest, withJSONObject: jsonObject)
            return urlRequest
        }
    }

    func requestToBody(_ request: Encodable) -> Data? {
        do {
            return try CodableManager.shared.jsonEncoding(from: request)
        } catch {
            print("requestToBody Error")
            return nil
        }
    }
}
