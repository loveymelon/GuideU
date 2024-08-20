//
//  DetailErrorDTO.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/20/24.
//

import Foundation

struct DetailErrorDTO: DTO {
    let loc: [LocDTO]
    let msg: String
    let type: String
}
