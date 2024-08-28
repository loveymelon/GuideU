//
//  DetailedErrorEntity.swift
//  GuideU
//
//  Created by 김진수 on 8/28/24.
//

import Foundation

struct DetailedErrorEntity: ErrorEntity {
      let detail: [DetailErrorEntity]
}
