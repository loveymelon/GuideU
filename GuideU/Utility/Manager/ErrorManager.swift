//
//  ErrorManager.swift
//  GuideU
//
//  Created by 김진수 on 9/13/24.
//

import Foundation
import ComposableArchitecture

// 유저 에러: 네트워크 단절, 과호출, 영상이 없을때, 우왁굳 유튜브가 아닐때
// 개발자 에러: 나머지는 print처리

enum NetworkErrorType {
    
}

struct ErrorManager {
    // fetchvideo엔 있지만 밈 캐릭터 정보가 없는 경우 -> 검출된 정보가 없습니다.
    // 네트워크 에러로 변환이 가능한 경우 중 네트워크 단절일때 네트워크 확인 요청
    // 네트워크 과호출 잠시후
    // 서버 오류일때 서버가 원할하지 않습니다.
    // 나머지 에러 print
    
    // 이 친구가 유저 에러인지, 개발자 에러인지 체크
}

//extension ErrorManager: DependencyKey {
//    static let liveValue: ErrorManager = Self()
//}
//
//extension DependencyValues {
//    var errorManager: ErrorManager {
//        get { self[ErrorManager.self] }
//        set { self[ErrorManager.self] = newValue }
//    }
//}
