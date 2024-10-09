//
//  GuideUShareConst.swift
//  GuideUShareExtension
//
//  Created by Jae hyung Kim on 10/9/24.
//

import Foundation

enum GuideUShareConst {
    static let urlScheme = "GuideU://"
    // SuiteName
    static let appGroupID = "group.guideu.youtube"
    static let userDefaultKey = "sharedURL"
}

extension GuideUShareConst {
    enum ShareViewText {
        static let loading = "불러오는 중입니다."
        static let checkedGuide = "가이두에서 확인하기"
    }
}
