//
//  Const.swift
//  GuideU
//
//  Created by Jae hyung Kim on 8/12/24.
//

import Foundation

enum Const {
    /// EX) 1
    static let appVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Error"
    /// EX) 0.1.0
    static let appShortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Error"
    // 출시후 실제 앱 ID
    static let appID = "com.WoowakGuide.GuideU"
    
    static let youtubeBaseString = "https://www.youtube.com/watch?v="
    
    static let channelImageBaseString = "https://photo.waksight.com/channel/"
    
    static let youtubeBaseURL = "https://www.youtube.com/"
    
    static let appName = "가이두"
    
    enum Splash {
        static let splashText = "왁타버스를 여행하는\n팬치, 이파리들을\n위한 안내서"
    }
    
    /// UpdateAt 기준 최신순 정렬 바랍니다.
    /// 홈화면 에서 사용되는 인물 열겨헝입니다.
    /// 각 이름과 채널 아이디들을 제공합니다.
    enum Channel: CaseIterable {
        case all
        case wakgood
        case ine
        case jingburger
        case lilpa
        case jururu
        case gosegu
        case viichan
        
        var mainTitle: String {
            switch self {
            case .all:
                return "모든 분들"
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
        
        var menuTitle: String {
            switch self {
            case .all:
                return "모든 분들"
            case .wakgood:
                return Wakgood.name + " 님"
            case .ine:
                return INE.name + " 님"
            case .jingburger:
                return JINGBURGER.name + " 님"
            case .lilpa:
                return Lilpa.name + " 님"
            case .jururu:
                return JURURU.name + " 님"
            case .gosegu:
                return GOSEGU.name + " 님"
            case .viichan:
                return VIichan.name + " 님"
            }
        }
        
        var channelIDs: [String] {
            switch self {
            case .all:
                return []
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
        
        func getChannelImageURL(channelId: String) -> URL? {
            let base = Const.channelImageBaseString
            let urlString: String
            
            switch self {
            case .all:
                if let wakURL = Const.Wakgood.allCases.first(where: { $0.id == channelId })?.imageURLString {
                    urlString = base + wakURL
                } else if let ineURL = Const.INE.allCases.first(where: { $0.id == channelId })?.imageURLString {
                    urlString = base + ineURL
                } else if let jingURL = Const.JINGBURGER.allCases.first(where: { $0.id == channelId })?.imageURLString {
                    urlString = base + jingURL
                } else if let lilpaURL = Const.Lilpa.allCases.first(where: { $0.id == channelId })?.imageURLString {
                    urlString = base + lilpaURL
                } else if let jururuURL = Const.JURURU.allCases.first(where: { $0.id == channelId })?.imageURLString {
                    urlString = base + jururuURL
                } else if let goseURL = Const.GOSEGU.allCases.first(where: { $0.id == channelId })?.imageURLString {
                    urlString = base + goseURL
                } else if let viichanURL = Const.VIichan.allCases.first(where: { $0.id == channelId })?.imageURLString {
                    urlString = base + viichanURL
                } else {
                    urlString = ""
                }
            case .wakgood:
                urlString = base + (Const.Wakgood.allCases.first { $0.id == channelId }?.imageURLString ?? "")
            case .ine:
                urlString = base + (Const.INE.allCases.first { $0.id == channelId }?.imageURLString ?? "")
            case .jingburger:
                urlString = base + (Const.JINGBURGER.allCases.first { $0.id == channelId }?.imageURLString ?? "")
            case .lilpa:
                urlString = base + (Const.Lilpa.allCases.first { $0.id == channelId }?.imageURLString ?? "")
            case .jururu:
                urlString = base + (Const.JURURU.allCases.first { $0.id == channelId }?.imageURLString ?? "")
            case .gosegu:
                urlString = base + (Const.GOSEGU.allCases.first { $0.id == channelId }?.imageURLString ?? "")
            case .viichan:
                urlString = base + (Const.VIichan.allCases.first { $0.id == channelId }?.imageURLString ?? "")
            }
            
            return URL(string: urlString)
        }
        
        static func findURL(channelId: String) -> URL? {
            let base = Const.channelImageBaseString
            let urlString: String
            
            if let wakURL = Const.Wakgood.allCases.first(where: { $0.id == channelId })?.imageURLString {
                urlString = base + wakURL
            } else if let ineURL = Const.INE.allCases.first(where: { $0.id == channelId })?.imageURLString {
                urlString = base + ineURL
            } else if let jingURL = Const.JINGBURGER.allCases.first(where: { $0.id == channelId })?.imageURLString {
                urlString = base + jingURL
            } else if let lilpaURL = Const.Lilpa.allCases.first(where: { $0.id == channelId })?.imageURLString {
                urlString = base + lilpaURL
            } else if let jururuURL = Const.JURURU.allCases.first(where: { $0.id == channelId })?.imageURLString {
                urlString = base + jururuURL
            } else if let goseURL = Const.GOSEGU.allCases.first(where: { $0.id == channelId })?.imageURLString {
                urlString = base + goseURL
            } else if let viichanURL = Const.VIichan.allCases.first(where: { $0.id == channelId })?.imageURLString {
                urlString = base + viichanURL
            } else {
                urlString = ""
            }
            return URL(string: urlString)
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
    static let navTitle = "왁타버스 대백과"
    static let placeHolderText = "알고싶은 왁타버스 영상을 여기에"
    
    static let noResultMent = "검색 결과가 없습니다."
    
    static let deleteMent = "검색어를 삭제하였습니다."
    static let allDeleteMent = "전체 검색어를 삭제하였습니다."
    
    enum noResultReason: CaseIterable {
        case check
        case other
        case noResult
        
        var text: String {
            switch self {
            case .check:
                "﹒검색어의 철자가 정확한지 확인해 주세요."
            case .other:
                "﹒비슷한 다른 검색어를 입력해보세요."
            case .noResult:
                "﹒데이터가 존재하지 않은 검색어일 수 있습니다."
            }
        }
    }
}

// MARK: MorePersonView
extension Const {
    static let moreInfoText = "왁타버스 알아보기"
    static let moreCheckText = "이 영상을 다 알아봤다면?"
    enum MorePersonHeader {
        static let headerTop = "지금 알아보는 영상은?"
        static let title = "찾거나 없어요..."
        static let channelName = "누구 영상 일까요...."
        static let time = "00:00"
    }
    
}

extension Const {
    static let mean = "뜻"
    static let explain = "설명"
    static let related = "관련 컨텐츠"
    static let relatedURL = "관련 링크"
    static let recentFind = "최근 알아본"
}

extension Const {
    static let setting = "설정"
}

extension Const {
    
    enum ErrorDes {
        case noWak
        case noVideo
        case serverError
        case noData
        case searchNoData
        
        var title: String {
            switch self {
            case .noWak:
                return "데이터를 찾을수가 없습니다."
            case .noVideo:
                return "영상이 감지 되지 않았습니다!"
            case .serverError:
                return "왁타버스 서버에러입니다"
            case .noData:
                return "영상에서 검출된 정보가 없습니다!"
            case .searchNoData:
                return "열심히 찾아봤지만 정보가 없습니다!"
            }
        }
        
        var des: String {
            switch self {
            case .noWak:
                return "우왁굳, 이세돌, 고정 멤버, 아카데미 등의\n공식 채널의 앱이 아니거나\n아직 서버에 없는 동영상입니다!"
            case .noVideo:
                return "여러 문제로 에러가 났을 수 있습니다.\n최대한 빨리 고칠 수 있도록 항상 노력하는\n가이두 팀이 되겠습니다."
            case .serverError:
                return "여러 문제로 에러가 났을 수 있습니다.\n최대한 빨리 고칠 수 있도록 항상 노력하는\n가이두 팀이 되겠습니다."
            case .noData:
                return "영상을 찾아봤지만.. 정보가 존재 하지 않네요..\n만약 오류가 발생 한것 같으면\n가이두 팀에게 문의를 남겨주세요!"
            case .searchNoData:
                return "검색 정보를 찾아봤지만 정보가 존재 하지 않네요..\n만약 오류가 발생 한것 같으면\n가이두 팀에게 문의를 남겨주세요!"
            }
        }
    }
}

/// App Info
extension Const {
    static let navigationTitle = "앱 정보"
    static let sectionTitle = "소프트웨어 정보"
}

// Setting View
extension Const {
    
    static let appInfo = "앱 정보"
    
    static let theme = "테마 설정"
    
    static let credit = "크레딧"
}

// MARK: 왁타버스 알아보기
extension Const {
    static let youtubeSection = "메인 유튜브"
    static let soopSection = "숲(아프리카TV)"
    static let xTwitterSection = "X(트위터)"
    static let instagramSection = "인스타그램"
    
}

// MARK: 유공자
extension Const {
    
    enum CreditCase: CaseIterable {
        case firstMerit
        case secondMerit
        
        var title: String {
            switch self {
            case .firstMerit: return "⓵  1차 유공자"
            case .secondMerit: return "⓶  2차 유공자"
            }
        }
    }
    
    enum FirstTealmRole: CaseIterable {
        case teamLeader // TeamLeader
        case pm
        case planning
        case developer
        case fe
        case be
        case ai
        case uiUx
        case infra
        case info
        case labelling
        case specialThanks
        
        static var mainTitle: String {return "1차 유공자"}
        
        var title: String {
            switch self {
            case .teamLeader: return "팀장"
            case .pm: return "PM"
            case .planning: return "기획"
            case .developer: return "개발"
            case .fe: return "FE"
            case .be: return "BE"
            case .ai: return "AI"
            case .uiUx: return "UI/UX"
            case .infra: return "인프라"
            case .info: return "정보팀"
            case .labelling: return "라벨링"
            case .specialThanks: return "Special Thanks"
            }
        }
        
        var member: String {
            switch self {
            case .teamLeader: return "강아지는 개과"
            case .pm: return "애교"
            case .planning: return "팀장 다이노소어\n기록자 영고"
            case .developer: return "리드 텔콘타르"
            case .fe: return "팀장 오영로크\n젤리마요, 차뫼"
            case .be: return "팀장 앙쓰\n반개, 트렌비, 애교"
            case .ai: return "팀장 Korshort\n러디, 이플(epl), 텔콘타르"
            case .uiUx: return "팀장 상헌\n하찐, 마넌"
            case .infra: return "식용뚤기, 민하쿠"
            case .info: return """
팀장 완전세균입니다
우왁굳 뉴누, 양사유, 김커일, 카레향연어
아이네 미식이, 나모링
징버거 빠나, 콩붕어
릴파 익스플로어, 애애
주르르 뮤 런, 루더, 르릇당, 주반
고세구 완전세균입니다, 구독금연
비챤 바람곰도리, 새벽밤하늘
"""
            case .labelling: return "그적미적, Sanyang"
            case .specialThanks: return "감람스톤\n유입가이드\n하벤하이드"
            }
        }
        
        static var textGrayOptions: [String] {
            return [
                "팀장",
                "리드",
                "우왁굳",
                "아이네",
                "징버거",
                "릴파",
                "주르르",
                "고세구",
                "비챤",
                "감람스톤",
                "유입가이드",
                "하벤하이드"
            ]
        }
        
        var paddingOptions: Bool {
            switch self {
                
            case .fe:
                return true
                
            default:
                return false
            }
        }
    }
}
