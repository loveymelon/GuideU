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
    func dtoToEntity(_ dtos: [VideosDTO]) -> [VideosEntity] {
        return dtos.map { dtoToEntity($0) }
    }
}

extension VideoMapper {
    private func dtoToEntity(_ dto: VideosDTO) -> VideosEntity {
        return VideosEntity(videoURL: URL(string: Const.youtubeBaseString + dto.identifier), channelName: dto.channelName, videoImageURL: URL(string: dto.thumbnailUrl), updatedAt: dto.updatedAt.toDate ?? Date(), channelImageURL: nil, title: dto.title)
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

