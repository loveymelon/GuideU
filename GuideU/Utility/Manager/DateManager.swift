//
//  DateManager.swift
//  GuideU
//
//  Created by 김진수 on 8/29/24.
//

import Foundation

// MARK: Swift 6 대응 -> 데이터 레이스 현상이 일어날 부분이 보이지가 않는다고 판단.
final class DateManager: @unchecked Sendable {
    
    private init() {}
    static let shared = DateManager()
    
    private let isoDateFormatter = ISO8601DateFormatter()
    private let dateFormatter = DateFormatter()
    private let locale = Locale(identifier:"ko_KR")
    
    enum dateFormatType: String {
        /// "yy. MM. dd"
        case slimYDM = "yy. MM. dd"
        /// "yyyy년 M월 d일"
        case fullType = "yyyy년 M월 d일"
        /// "a hh:mm"
        case roomListType = "a hh:mm"
        /// "a hh시 mm분"
        case rightChatType = "a hh시 mm분"
        /// "hh시 mm분 a"
        case leftChatType = "hh시 mm분 a"
        
        var format: String { return self.rawValue }
    }
    
    func toDate(_ dateString: String) -> Date? {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.locale = locale

        if let fallbackResult = dateFormatter.date(from: dateString) {
            return fallbackResult
        }
        #if DEBUG
        print("fail")
        #endif
        return nil
    }
    
    func toDate(_ dateString: String, format: dateFormatType) -> String {
        guard let fallbackResult = toDate(dateString) else {
            return ""
        }
        return toString(date: fallbackResult, format: format)
    }
    func toString(date: Date, format: dateFormatType) -> String {
        dateFormatter.dateFormat = format.format
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }
    
    func toDateISO(_ dateString: String) -> Date? {
        var calendar = Calendar.current
        
        isoDateFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        calendar.timeZone = .current
        
        return isoDateFormatter.date(from: dateString)
    }
    
    func toDateISO(_ date: Date) -> String {
        
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        return isoDateFormatter.string(from: date)
    }
    
    func asDateToString(_ date: Date?) -> String {
        guard let date else { return "" }
        
        dateFormatter.dateFormat = dateFormatType.slimYDM.format
        
        return dateFormatter.string(from: date)
    }
    
    func dateToStringToChat(_ date: Date, isMe: Bool) -> String {
        if isMe {
            dateFormatter.dateFormat = dateFormatType.rightChatType.format
        } else {
            dateFormatter.dateFormat = dateFormatType.rightChatType.format
        }
        
        dateFormatter.locale = locale
        
        return dateFormatter.string(from: date)
    }
    
    func dateToStringToChatSection(_ date: Date) -> String {
        let format = dateFormatType.fullType.format
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        dateFormatter.locale = locale
        
        return dateFormatter.string(from: date)
    }
    
    func dateToStringToRoomList(_ date: Date) -> String {
    
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = dateFormatType.roomListType.format
        } else {
            dateFormatter.dateFormat = dateFormatType.fullType.format
        }
        
        return dateFormatter.string(from: date)
    }
    
}
