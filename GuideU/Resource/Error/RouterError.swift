//
//  RouterError.swift
//  GuideU
//
//  Created by Jae hyung Kim on 10/14/24.
//

import Foundation

enum RouterError: Error {
    case urlFail(url: String = "")
    case decodingFail
    case encodingFail
    case unknown
}
