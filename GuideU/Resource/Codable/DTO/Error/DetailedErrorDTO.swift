//
//  DetailedErrorDTO.swift
//  GuideU
//
//  Created by 김진수 on 8/28/24.
//

import Foundation

struct DetailedErrorDTO: ErrorDTO {
    let detail: [DetailErrorDTO]
}
