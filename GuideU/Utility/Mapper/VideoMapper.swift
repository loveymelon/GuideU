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
    func dtoToEntity(_ dtos: [VideosDTO], channel: Const.Channel, channelID: String) -> [VideosEntity] {
        return dtos.map { dtoToEntity($0, channel: channel, channelID: channelID) }
    }
}

extension VideoMapper {
    private func dtoToEntity(_ dto: VideosDTO, channel: Const.Channel, channelID: String) -> VideosEntity {
        return VideosEntity(
            videoURL: URL(
                string: Const.youtubeBaseString + dto.identifier
            ),
            channelName: dto.channelName,
            videoImageURL: URL(
                string: dto.thumbnailUrl
            ),
            updatedAt: dto.updatedAt.toDate ?? Date(),
            channelImageURL: getChannelImageURL(channel: channel, channelId: channelID),
            title: dto.title
        )
    }
    
    private func getChannelImageURL(channel: Const.Channel, channelId: String) -> URL? {
        let urlString: String
        
        switch channel {
        case .wakgood:
            urlString = Const.channelImageBaseString + (Const.Wakgood.allCases.first { $0.id == channelId }?.imageURLString ?? "")
        case .ine:
            urlString = Const.channelImageBaseString + (Const.INE.allCases.first { $0.id == channelId }?.imageURLString ?? "")
        case .jingburger:
            urlString = Const.channelImageBaseString + (Const.JINGBURGER.allCases.first { $0.id == channelId }?.imageURLString ?? "")
        case .lilpa:
            urlString = Const.channelImageBaseString + (Const.Lilpa.allCases.first { $0.id == channelId }?.imageURLString ?? "")
        case .jururu:
            urlString = Const.channelImageBaseString + (Const.JURURU.allCases.first { $0.id == channelId }?.imageURLString ?? "")
        case .gosegu:
            urlString = Const.channelImageBaseString + (Const.GOSEGU.allCases.first { $0.id == channelId }?.imageURLString ?? "")
        case .viichan:
            urlString = Const.channelImageBaseString + (Const.VIichan.allCases.first { $0.id == channelId }?.imageURLString ?? "")
        }
        
        return URL(string: urlString)
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

