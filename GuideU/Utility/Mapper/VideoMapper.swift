//
//  VideoMapper.swift
//  GuideU
//
//  Created by 김진수 on 8/29/24.
//

import Foundation
import ComposableArchitecture

final class VideoMapper: Sendable {
    /// [VideosDTO] -> [VideosEntity]
//    func dtoToEntity(_ dtos: [VideosDTO], channel: Const.Channel = .wakgood, channelID: String = "") -> [VideosEntity] {
//        return dtos.map { dtoToEntity($0, channel: channel, channelID: channelID) }
//    }
    
    func dtoToEntity(_ dtos: [VideosDTO], channel: Const.Channel = .wakgood, channelID: String = "") async -> [VideosEntity] {
        return await dtos.asyncMap { dtoToEntity($0, channel: channel, channelID: channelID) }
    }
    
    /// [VideosDTO] -> [HeaderEntity] 비동기 변환
    func dtoToEntityToHeader(_ dtos: [VideosDTO], channel: Const.Channel = .wakgood, channelID: String = "") async -> [HeaderEntity] {
        return await dtos.asyncMap { dtoToEntityToHeader($0, channel: channel, channelID: channelID) }
    }
    
    func requestDTOToEntity(_ requestDTO: [VideoHistoryRequestDTO]) async -> [VideosEntity] {
        return await requestDTO.asyncMap { requestDTOToEntity($0) }
    }
    
    func requestDTOToEntity(_ requestDTO: VideoHistoryRequestDTO) -> VideosEntity {
        return VideosEntity(identifier: requestDTO.identifier, videoURL: URL(string: requestDTO.videoURL), channelName: requestDTO.channelName, videoImageURL: URL(string: requestDTO.thumbnail), updatedAt: requestDTO.updatedAt, channelImageURL: URL(string: requestDTO.channelImage), title: requestDTO.title)
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
            channelImageURL: openImageURL(Const.Channel.findURL(channelId: dto.channelId)),
            title: dto.title
        )
    }
    
    private func dtoToEntityToHeader(_ dto: VideosDTO, channel: Const.Channel, channelID: String) -> HeaderEntity {
        return HeaderEntity(
            title: dto.title,
            channelName: dto.channelName,
            time: dto.updatedAt.toDate(dateFormat: .fullType),
            thumImage: URL(string: dto.thumbnailUrl),
            updatedAt: dto.updatedAt.toDate ?? Date()
        )
    }
}

extension VideoMapper {
    private func openImageURL(_ url: URL?) -> URL? {
        let validExtensions = ["jpg", "jpeg", "png"]  // 허용할 이미지 파일 확장자 목록
        
        guard let fileExtension = url?.pathExtension.lowercased() else { return nil }
        
        if validExtensions.contains(fileExtension) {
            return url
        }
        return nil
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
        let result = groupedData.sorted { $0.key > $1.key }
        return sortedVideo(datas: result)
    }
    
    private func sortedVideo(datas: [Dictionary<Date, [VideosEntity]>.Element]) -> [HistoryVideosEntity] {
        let calendar = Calendar.current
        let dayOption = settingToDivideDay()
        var result = [HistoryVideosEntity]()
        
        for (date, contents) in datas {
            var title: String = ""
            
            if calendar.isDate(date, inSameDayAs: dayOption.now) {
                title = "오늘"
            } else if calendar.isDate(date, inSameDayAs: dayOption.yesterDay) {
                title = "어제"
            } else {
                let trans = DateManager.shared.toString(date: date, format: .fullType)
                title = trans
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
    static let liveValue: VideoMapper = VideoMapper()
}

extension DependencyValues {
    var videoMapper: VideoMapper {
        get { self[VideoMapper.self] }
        set { self[VideoMapper.self] = newValue }
    }
}

