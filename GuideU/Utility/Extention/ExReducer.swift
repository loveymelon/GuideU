//
//  ExReducer.swift
//  GuideU
//
//  Created by 김진수 on 10/15/24.
//

import ComposableArchitecture

extension Reducer {
    func errorHandling(_ error: Error) -> String? {
        if let networkAPIError = error as? NetworkAPIError {
            switch networkAPIError {
            case let .routerError(error):
                print("routerError", error)
            case let .viewError(error):
                print(error)
                if case let .msg(msg) = error {
                    return msg
                }
            case let .realmError(error):
                print(error)
                return error.description
            }
        }
        return nil
    }
}
