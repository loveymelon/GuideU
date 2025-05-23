//
//  AlertMessage.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/21/24.
//

import Foundation

enum AlertMessage: Equatable {
    
    case networkPathError(String? = nil)
    case networkError(String? = nil)
    case severError(String? = nil)
    
    var title : String {
        switch self {
        case .networkPathError:
            "네트워크 상태 확인"
        case .networkError:
            "네트워크 에러"
        case .severError:
            "서버 에러"
        }
    }
    
    var actionTitle: String {
        switch self {
        case .networkPathError, .networkError, .severError:
            return "확인"
        }
    }
    
    var message: String {
        switch self {
        case let .networkPathError(message):
            guard let message else {
                return "네트워크 연결 상태가 좋지 않습니다. 네트워크 상태를 체크해주세요."
            }
            return message
        case let .networkError(message):
            guard let message else {
                return "네트워크 문제가 발생 하였습니다."
            }
            return message
        case let .severError(message):
            guard let message else {
                return "왁타버스 서버에서 문제가 생겼습니다.\n잠시후에 다시 시도해주세요."
            }
            return message
        }
    }
    
    var cancelTitle: String? {
        switch self {
        case .networkError:
            return nil
        case .networkPathError:
            return nil
        case .severError:
            return nil
        }
    }
}
