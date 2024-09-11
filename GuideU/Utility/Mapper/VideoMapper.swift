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
    
    private func requestDTOToEntity(_ requestDTO: VideoHistoryRequestDTO) -> VideosEntity {
        return VideosEntity(identifier: requestDTO.identifier, videoURL: URL(string: requestDTO.videoURL), channelName: requestDTO.channelName, videoImageURL: URL(string: requestDTO.thumbnail), updatedAt: requestDTO.updatedAt, channelImageURL: nil, title: requestDTO.title)
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

