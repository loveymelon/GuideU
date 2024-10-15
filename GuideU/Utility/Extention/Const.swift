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
                    print(urlString)
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
                "WAKBANCHAN.jpeg"
            case .zero:
                "WAKFULL.jpeg"
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
                
            case .fe, .be:
                return true
                
            default:
                return false
            }
        }
    }
    
    
    enum openSourceLicense: String, CaseIterable {
        case ComposableArchitecture
        case TCACoordinators
        case Alamofire
        case Firebase
        case Kingfisher
        case Realm = "Realm - Swift"
        case Lottie
        case Apache = "Apache License 2.0"
        case MIT = "MIT License"
        
        var title: String {
            self.rawValue
        }
        
        var subTitle: String {
            return switch self {
            case .ComposableArchitecture:
                "MIT License\nCopyright (c) 2020 Point-Free, Inc."
            case .TCACoordinators:
                "MIT License\nCopyright (c) 2021 johnpatrickmorgan"
            case .Alamofire:
                "MIT License\nCopyright (c) 2014-2022 Alamofire Software Foundation"
            case .Firebase:
                "is licensed under the Apache Version 2.0"
            case .Kingfisher:
                "The MIT License (MIT)\nCopyright (c) 2019 Wei Wang"
            case .Realm:
                "is licensed under the Apache Version 2.0"
            case .Lottie:
                "is licensed under the Apache Version 2.0"
            case .Apache:
                """
Apache License
Version 2.0, January 2004
https://www.apache.org/licenses/

TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

1. Definitions.

    "License" shall mean the terms and conditions for use, reproduction,
    and distribution as defined by Sections 1 through 9 of this document.

    "Licensor" shall mean the copyright owner or entity authorized by
    the copyright owner that is granting the License.

    "Legal Entity" shall mean the union of the acting entity and all
    other entities that control, are controlled by, or are under common
    control with that entity. For the purposes of this definition,
    "control" means (i) the power, direct or indirect, to cause the
    direction or management of such entity, whether by contract or
    otherwise, or (ii) ownership of fifty percent (50%) or more of the
    outstanding shares, or (iii) beneficial ownership of such entity.

    "You" (or "Your") shall mean an individual or Legal Entity
    exercising permissions granted by this License.

    "Source" form shall mean the preferred form for making modifications,
    including but not limited to software source code, documentation
    source, and configuration files.

    "Object" form shall mean any form resulting from mechanical
    transformation or translation of a Source form, including but
    not limited to compiled object code, generated documentation,
    and conversions to other media types.

    "Work" shall mean the work of authorship, whether in Source or
    Object form, made available under the License, as indicated by a
    copyright notice that is included in or attached to the work
    (an example is provided in the Appendix below).

    "Derivative Works" shall mean any work, whether in Source or Object
    form, that is based on (or derived from) the Work and for which the
    editorial revisions, annotations, elaborations, or other modifications
    represent, as a whole, an original work of authorship. For the purposes
    of this License, Derivative Works shall not include works that remain
    separable from, or merely link (or bind by name) to the interfaces of,
    the Work and Derivative Works thereof.

    "Contribution" shall mean any work of authorship, including
    the original version of the Work and any modifications or additions
    to that Work or Derivative Works thereof, that is intentionally
    submitted to Licensor for inclusion in the Work by the copyright owner
    or by an individual or Legal Entity authorized to submit on behalf of
    the copyright owner. For the purposes of this definition, "submitted"
    means any form of electronic, verbal, or written communication sent
    to the Licensor or its representatives, including but not limited to
    communication on electronic mailing lists, source code control systems,
    and issue tracking systems that are managed by, or on behalf of, the
    Licensor for the purpose of discussing and improving the Work, but
    excluding communication that is conspicuously marked or otherwise
    designated in writing by the copyright owner as "Not a Contribution."

    "Contributor" shall mean Licensor and any individual or Legal Entity
    on behalf of whom a Contribution has been received by Licensor and
    subsequently incorporated within the Work.

2. Grant of Copyright License. Subject to the terms and conditions of
    this License, each Contributor hereby grants to You a perpetual,
    worldwide, non-exclusive, no-charge, royalty-free, irrevocable
    copyright license to reproduce, prepare Derivative Works of,
    publicly display, publicly perform, sublicense, and distribute the
    Work and such Derivative Works in Source or Object form.

3. Grant of Patent License. Subject to the terms and conditions of
    this License, each Contributor hereby grants to You a perpetual,
    worldwide, non-exclusive, no-charge, royalty-free, irrevocable
    (except as stated in this section) patent license to make, have made,
    use, offer to sell, sell, import, and otherwise transfer the Work,
    where such license applies only to those patent claims licensable
    by such Contributor that are necessarily infringed by their
    Contribution(s) alone or by combination of their Contribution(s)
    with the Work to which such Contribution(s) was submitted. If You
    institute patent litigation against any entity (including a
    cross-claim or counterclaim in a lawsuit) alleging that the Work
    or a Contribution incorporated within the Work constitutes direct
    or contributory patent infringement, then any patent licenses
    granted to You under this License for that Work shall terminate
    as of the date such litigation is filed.

4. Redistribution. You may reproduce and distribute copies of the
    Work or Derivative Works thereof in any medium, with or without
    modifications, and in Source or Object form, provided that You
    meet the following conditions:

    (a) You must give any other recipients of the Work or
        Derivative Works a copy of this License; and

    (b) You must cause any modified files to carry prominent notices
        stating that You changed the files; and

    (c) You must retain, in the Source form of any Derivative Works
        that You distribute, all copyright, patent, trademark, and
        attribution notices from the Source form of the Work,
        excluding those notices that do not pertain to any part of
        the Derivative Works; and

    (d) If the Work includes a "NOTICE" text file as part of its
        distribution, then any Derivative Works that You distribute must
        include a readable copy of the attribution notices contained
        within such NOTICE file, excluding those notices that do not
        pertain to any part of the Derivative Works, in at least one
        of the following places: within a NOTICE text file distributed
        as part of the Derivative Works; within the Source form or
        documentation, if provided along with the Derivative Works; or,
        within a display generated by the Derivative Works, if and
        wherever such third-party notices normally appear. The contents
        of the NOTICE file are for informational purposes only and
        do not modify the License. You may add Your own attribution
        notices within Derivative Works that You distribute, alongside
        or as an addendum to the NOTICE text from the Work, provided
        that such additional attribution notices cannot be construed
        as modifying the License.

    You may add Your own copyright statement to Your modifications and
    may provide additional or different license terms and conditions
    for use, reproduction, or distribution of Your modifications, or
    for any such Derivative Works as a whole, provided Your use,
    reproduction, and distribution of the Work otherwise complies with
    the conditions stated in this License.

5. Submission of Contributions. Unless You explicitly state otherwise,
    any Contribution intentionally submitted for inclusion in the Work
    by You to the Licensor shall be under the terms and conditions of
    this License, without any additional terms or conditions.
    Notwithstanding the above, nothing herein shall supersede or modify
    the terms of any separate license agreement you may have executed
    with Licensor regarding such Contributions.

6. Trademarks. This License does not grant permission to use the trade
    names, trademarks, service marks, or product names of the Licensor,
    except as required for reasonable and customary use in describing the
    origin of the Work and reproducing the content of the NOTICE file.

7. Disclaimer of Warranty. Unless required by applicable law or
    agreed to in writing, Licensor provides the Work (and each
    Contributor provides its Contributions) on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
    implied, including, without limitation, any warranties or conditions
    of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
    PARTICULAR PURPOSE. You are solely responsible for determining the
    appropriateness of using or redistributing the Work and assume any
    risks associated with Your exercise of permissions under this License.

8. Limitation of Liability. In no event and under no legal theory,
    whether in tort (including negligence), contract, or otherwise,
    unless required by applicable law (such as deliberate and grossly
    negligent acts) or agreed to in writing, shall any Contributor be
    liable to You for damages, including any direct, indirect, special,
    incidental, or consequential damages of any character arising as a
    result of this License or out of the use or inability to use the
    Work (including but not limited to damages for loss of goodwill,
    work stoppage, computer failure or malfunction, or any and all
    other commercial damages or losses), even if such Contributor
    has been advised of the possibility of such damages.

9. Accepting Warranty or Additional Liability. While redistributing
    the Work or Derivative Works thereof, You may choose to offer,
    and charge a fee for, acceptance of support, warranty, indemnity,
    or other liability obligations and/or rights consistent with this
    License. However, in accepting such obligations, You may act only
    on Your own behalf and on Your sole responsibility, not on behalf
    of any other Contributor, and only if You agree to indemnify,
    defend, and hold each Contributor harmless for any liability
    incurred by, or claims asserted against, such Contributor by reason
    of your accepting any such warranty or additional liability.

END OF TERMS AND CONDITIONS

APPENDIX: How to apply the Apache License to your work.

    To apply the Apache License to your work, attach the following
    boilerplate notice, with the fields enclosed by brackets "{}"
    replaced with your own identifying information. (Don't include
    the brackets!)  The text should be enclosed in the appropriate
    comment syntax for the file format. We also recommend that a
    file or class name and description of purpose be included on the
    same "printed page" as the copyright notice for easier
    identification within third-party archives.

Copyright 2018 Airbnb, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""
            case .MIT:
                """
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""
            }
        }
        
        var urlString: String {
            return switch self {
            case .ComposableArchitecture:
                "https://github.com/pointfreeco/swift-composable-architecture"
            case .TCACoordinators:
                "https://github.com/johnpatrickmorgan/TCACoordinators"
            case .Alamofire:
                "http://alamofire.org/"
            case .Firebase:
                "https://github.com/firebase/firebase-ios-sdk"
            case .Kingfisher:
                "https://github.com/onevcat/Kingfisher"
            case .Realm:
                "https://github.com/realm/realm-swift"
            case .Lottie:
                "https://github.com/airbnb/lottie-ios"
            case .Apache:
                "https://www.apache.org/licenses/"
            case .MIT:
                ""
            }
        }
    }
}

