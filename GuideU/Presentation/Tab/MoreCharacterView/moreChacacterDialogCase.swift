//
//  moreChacacterDialogCase.swift
//  GuideU
//
//  Created by Jae hyung Kim on 9/11/24.
//

import Foundation

enum MoreCharacterDialog: String, CaseIterable {
    static let title = "이동"

    case buttonTitle1 = "링크로 이동하기"
    case buttonTitle2 = "영상 정보 알아보기"
    
    var buttonTitle: String {
        return self.rawValue
    }
}
