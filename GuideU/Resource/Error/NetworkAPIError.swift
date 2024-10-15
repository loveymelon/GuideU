//
//  NetworkAPIError.swift
//  GuideU
//
//  Created by 김진수 on 10/14/24.
//

import Foundation

enum NetworkAPIError: Error {
    case routerError(RouterError)
    case viewError(ViewError)
    case realmError(RealmError)
}

enum ViewError: Error {
    case msg(String)
}
