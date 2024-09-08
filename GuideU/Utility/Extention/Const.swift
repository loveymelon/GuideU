//
//  Const.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/12/24.
//

import Foundation

enum Const {
    
    static let youtubeBaseString = "https://www.youtube.com/watch?v="
    
    static let channelImageBaseString = "https://photo.waksight.com/channel/"
    
    enum Splash {
        static let splashText = "왁타버스를 여행하는\n팬치, 이파리들을\n위한 안내서"
    }
    
    /// UpdateAt 기준 최신순 정렬 바랍니다.
    /// 홈화면 에서 사용되는 인물 열겨헝입니다.
    /// 각 이름과 채널 아이디들을 제공합니다.
    enum Channel: CaseIterable {
        case wakgood
        case ine
        case jingburger
        case lilpa
        case jururu
        case gosegu
        case viichan
        
        var name: String {
            switch self {
            case .wakgood:
                return Wakgood.name
            case .ine:
                return INE.name
            case .jingburger:
                return JINGBURGER.name
            case .lilpa:
                return Lilpa.name
            case .jururu:
                return JURURU.name
            case .gosegu:
                return GOSEGU.name
            case .viichan:
                return VIichan.name
            }
        }
        
        var channelIDs: [String] {
            switch self {
            case .wakgood:
                return Wakgood.allCases.map { $0.id }
            case .ine:
                return INE.allCases.map { $0.id }
            case .jingburger:
                return JINGBURGER.allCases.map { $0.id }
            case .lilpa:
                return Lilpa.allCases.map { $0.id }
            case .jururu:
                return JURURU.allCases.map { $0.id }
            case .gosegu:
                return GOSEGU.allCases.map { $0.id }
            case .viichan:
                return VIichan.allCases.map { $0.id }
            }
        }
    }
    
    enum Wakgood: CaseIterable {
        static let name = "우왁굳"
        
        case main
        case waktaverse
        case banchan
        case zero
        
        var id: String {
            return switch self {
            case .main:
                "UCBkyj16n2snkRg1BAzpovXQ"
            case .waktaverse:
                "UCzh4yY8rl38knH33XpNqXbQ"
            case .banchan:
                "UCZOcwheypMvYN_J2oRBgt2A"
            case .zero:
                "UChCqDNXQddSr0ncjs_78duA"
            }
        }
        
        var imageURLString: String {
            switch self {
            case .main:
                "WAKGOOD.jpg"
            case .waktaverse:
                "WAKTAVERSE.jpg"
            case .banchan:
                "WAKBANCHAN.jpg"
            case .zero:
                "WAKFULL.jpg"
            }
        }
        /*
         "UCBkyj16n2snkRg1BAzpovXQ": "우왁굳의 게임방송",
         "UCzh4yY8rl38knH33XpNqXbQ": "왁타버스 WAKTAVERSE",
         "UCZOcwheypMvYN_J2oRBgt2A": "우왁굳의 반찬가게",
         # "UChCqDNXQddSr0ncjs_78duA": "왁타버스 ZERO",
         */
    }
    
    enum INE: CaseIterable {
        static let name = "아이네"
        
        case main
        case sub
     // case full
        
        var id: String {
            return switch self {
            case .main:
                "UCroM00J2ahCN6k-0-oAiDxg"
            case .sub:
                "UCmHltryGykfakS-JmaxrNBg"
            }
        }
    
        var imageURLString: String {
            switch self {
            case .main:
                "INE.jpeg"
            case .sub:
                "INEDESUK.jpeg"
            }
        }
        /*
         "UCroM00J2ahCN6k-0-oAiDxg": "아이네 INE",
         "UCmHltryGykfakS-JmaxrNBg": "데친 숙주나물",
         # "UCBF6nBTgFN_xzrLMF9eiRhw": "아이네 다시보기",
         */
     
    }
    
    enum JINGBURGER: CaseIterable {
        static let name = "징버거"
        case main
        case sub
//        case full
        var id: String {
            return switch self {
            case .main:
                "UCHE7GBQVtdh-c1m3tjFdevQ"
            case .sub:
                "UC-S9NE-xzcBpxOFSvsmOzAA"
            }
        }
        var imageURLString: String {
            switch self {
            case .main:
                "JingBurgerChannel.jpeg"
            case .sub:
                "JINGBURGERZZANG.jpeg"
            }
        }
        /*
         "UCHE7GBQVtdh-c1m3tjFdevQ": "징버거 JINGBURGER",
         "UC-S9NE-xzcBpxOFSvsmOzAA": "징버거가 ZZANG센 주제에 너무 신중하다",
         # "UCrN7Gb8xIZF_0ZYA1cmVNxQ": "징버거 다시보기",
         */
    }
    
    enum Lilpa: CaseIterable {
        static let name = "릴파"
        
        case main
        case sub
//        case full
        
        var id: String {
            return switch self {
            case .main:
                "UC-oCJP9t47v7-DmsnmXV38Q"
            case .sub:
                "UC8dEJs2kpS5x2vI1X7aaUhA"
            }
        }
        
        var imageURLString: String {
            switch self {
            case .main:
                "LILPA.jpeg"
            case .sub:
                "LILPAGGOGGO.jpeg"
            }
        }
        /*
         "UC-oCJP9t47v7-DmsnmXV38Q": "릴파 lilpa",
         "UC8dEJs2kpS5x2vI1X7aaUhA": "릴파의 꼬꼬",
         # "UCp_jHNjcoiXC7SlElrBmzBA": "릴파 다시보기",
         */
    }
    
    enum JURURU: CaseIterable {
        static let name = "주르르"
        
        case main
        case sub
//        case full
        
        var id: String {
            return switch self {
            case .main:
                "UCTifMx1ONpElK5x6B4ng8eg"
            case .sub:
                "UCgGvSg2lscdNUx9ZJIBh9FQ"
            }
        }
        var imageURLString: String {
            switch self {
            case .main:
                "JURURU.jpeg"
            case .sub:
                "JURURUUNSEALED.jpeg"
            }
        }
        /*
         "UCTifMx1ONpElK5x6B4ng8eg": "주르르 JURURU",
         "UCgGvSg2lscdNUx9ZJIBh9FQ": "봉인 풀린 주르르",
         # "UCo28fS0LmlcyPcKItrZMPiQ": "주르르 다시보기",
         */
    }
    
    enum GOSEGU: CaseIterable {
        static let name = "고세구"
        
        case main
        case sub
//        case full
        
        var id: String {
            return switch self {
            case .main:
                "UCV9WL7sW6_KjanYkUUaIDfQ"
            case .sub:
                "UCSSPlgcyDA5eoN3hrkXpvHg"
            }
        }
        
        var imageURLString: String {
            switch self {
            case .main:
                "GOSEGU.jpeg"
            case .sub:
                "GOSEGUMORE.jpeg"
            }
        }
        /*
         "UCV9WL7sW6_KjanYkUUaIDfQ": "고세구 GOSEGU",
         "UCSSPlgcyDA5eoN3hrkXpvHg": "고세구의 좀 더",
         # "UCc4qGj6d8LBXW2qZ9GZQWqQ": "밥친구 고세구",
         */
    }
    
    enum VIichan: CaseIterable {
        static let name = "비챤"
        
        case main
        case sub
//        case full
        
        var id: String {
            return switch self {
            case .main:
                "UCs6EwgxKLY9GG4QNUrP5hoQ"
            case .sub:
                "UCuJUfqThFp5-k-lrHcO1dFg"
            }
        }
        
        var imageURLString: String {
            switch self {
            case .main:
                "VIICHAN.jpeg"
            case .sub:
                "VIICHANME.jpeg"
            }
        }
        /*
         "UCs6EwgxKLY9GG4QNUrP5hoQ": "비챤 VIichan",
         "UCuJUfqThFp5-k-lrHcO1dFg": "비챤의 나랑놀아",
         */
    }
}

// MARK: Search View Text
extension Const {
    static let recentSection = "최근 검색한"
    static let allClear = "전체삭제"
    static let navTitle = "검색"
    static let placeHolderText = "알고싶은 왁타버스 영상을 여기에"
}
