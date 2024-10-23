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
                #if DEBUG
                print("routerError", error)
                #endif
                return nil
            case let .viewError(error):
                #if DEBUG
                print(error)
                #endif
                if case let .msg(msg) = error {
                    return msg
                }
            case let .realmError(error):
                #if DEBUG
                print(error)
                #endif
                return error.description
            }
        }
        return nil
    }
}
