//
//  VideoMapper.swift
//  GuideU
//
//  Created by 김진수 on 8/29/24.
//

import Foundation
import ComposableArchitecture

struct VideoMapper {
    /// [VideosDTO] -> [VideosEntity]
    func dtoToEntity(_ dtos: [VideosDTO], channel: Const.Channel = .wakgood, channelID: String = "") -> [VideosEntity] {
        return dtos.map { dtoToEntity($0, channel: channel, channelID: channelID) }
    }
    
    func requestDTOToEntity(_ requestDTO: [VideoHistoryRequestDTO]) -> [VideosEntity] {
        return requestDTO.map { requestDTOToEntity($0) }
    }
    
    func dtoToEntityToHeader(_ dtos: [VideosDTO], channel: Const.Channel = .wakgood, channelID: String = "") -> [HeaderEntity] {
        return dtos.map { dtoToEntityToHeader($0, channel: channel, channelID: channelID) }
    }
    
    func requestDTOToEntity(_ requestDTO: VideoHistoryRequestDTO) -> VideosEntity {
        return VideosEntity(identifier: requestDTO.identifier, videoURL: URL(string: requestDTO.videoURL), channelName: requestDTO.channelName, videoImageURL: URL(string: requestDTO.thumbnail), updatedAt: requestDTO.updatedAt, channelImageURL: nil, title: requestDTO.title)
    }
}

extension VideoMapper {
    func dtoToEntity(_ dto: VideosDTO, channel: Const.Channel, channelID: String) -> VideosEntity {
        return VideosEntity(
            identifier: dto.identifier,
            videoURL: URL(
                string: Const.youtubeBaseString + dto.identifier
            ),
            channelName: dto.channelName,
            videoImageURL: URL(
                string: dto.thumbnailUrl
            ),
            updatedAt: dto.updatedAt.toDate ?? Date(),
            channelImageURL: channel.getChannelImageURL(channelId: channelID),
            title: dto.title
        )
    }
    
    private func dtoToEntityToHeader(_ dto: VideosDTO, channel: Const.Channel, channelID: String) -> HeaderEntity {
        return HeaderEntity(
            title: dto.title,
            channelName: dto.channelName,
            time: dto.updatedAt.toDate(dateFormat: .fullType),
            thumImage: URL(string: dto.thumbnailUrl),
            identifier: dto.identifier,
            videoURL: URL(string: Const.youtubeBaseString + dto.identifier),
            videoImage: URL(string: dto.thumbnailUrl),
            channelImageURL: channel.getChannelImageURL(channelId: dto.channelId),
            updatedAt: dto.updatedAt.toDate ?? Date()
        )
    }
}

// MARK: Date
extension VideoMapper {
    
    func dtoToEntity(dtos: [VideoHistoryRequestDTO]) -> [HistoryVideosEntity] {
        var groupedData = [Date: [VideosEntity]]()
        
        for item in dtos {
            let startOfDay = Calendar.current.startOfDay(for: item.watchedAt)
            
            if groupedData[startOfDay] == nil {
                groupedData[startOfDay] = [requestDTOToEntity(item)]
            } else {
                groupedData[startOfDay]?.append(requestDTOToEntity(item))
            }
        }
        
        return sortedVideo(datas: groupedData.sorted { $0.key < $1.key })
    }
    
    private func sortedVideo(datas: [Dictionary<Date, [VideosEntity]>.Element]) -> [HistoryVideosEntity] {
        let calendar = Calendar.current
        let dayOption = settingToDivideDay()
        var result = [HistoryVideosEntity]()
        
        for (date, contents) in datas {
            let title: String
            
            if calendar.isDate(date, inSameDayAs: dayOption.now) {
                title = "오늘"
            } else if calendar.isDate(date, inSameDayAs: dayOption.yesterDay) {
                title = "내일"
            } else {
                let dateToString = DateManager.shared.asDateToString(date)
                title = DateManager.shared.toDate(dateToString, format: .fullType)
            }
            result.append(HistoryVideosEntity(lastWatched: title, videosEntity: contents))
        }
        
        return result
    }
    
    private func settingToDivideDay() -> (now: Date, yesterDay: Date) {
        let calendar = Calendar.current
        let nowDate = Calendar.current.startOfDay(for: Date())
        let yesterDay = calendar.date(byAdding: .day, value: -1, to: nowDate) ?? Date()
        return (nowDate, yesterDay)
    }
}

extension VideoMapper: DependencyKey {
    static var liveValue: VideoMapper = VideoMapper()
}

extension DependencyValues {
    var videoMapper: VideoMapper {
        get { self[VideoMapper.self] }
        set { self[VideoMapper.self] = newValue }
    }
}

