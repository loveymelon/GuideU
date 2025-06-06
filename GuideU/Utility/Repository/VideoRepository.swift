//
//  VideoRepository.swift
//  GuideU
//
//  Created by 김진수 on 8/29/24.
//

import Foundation
import ComposableArchitecture

final class VideoRepository: @unchecked Sendable {
    @Dependency(\.networkManager) var network
    @Dependency(\.videoMapper) var videoMapper
    @Dependency(\.errorMapper) var errorMapper
    
    func fetchVideoHeader(identifier: String) async throws -> (header: HeaderEntity, video: VideosEntity)? {
        let data = try await network.requestNetwork(dto: VideoDTO.self, router: VideoRouter.fetchVideos(identifier: identifier))
        
        guard let headerFirst = data.videos.first,
              let headerData = await videoMapper.dtoToEntityToHeader([headerFirst]).first,
              let videoData = await videoMapper.dtoToEntity([headerFirst]).first else {
            return nil
        }
        
        return (headerData, videoData)
    }
    
    func fetchVideos(channel: Const.Channel, skip: Int = 0, limit: Int = 10) async throws -> [VideosEntity] {
        
        if channel.channelIDs.isEmpty {
            let data = try await network.requestNetwork(dto: VideoDTO.self, router: VideoRouter.fetchVideos(skip: skip, limit: limit))
            
            return await videoMapper.dtoToEntity(data.videos, channel: channel)
        } else {
            var tempData: [VideosEntity] = []
            
            for id in channel.channelIDs {
                let data = try await network.requestNetwork(dto: VideoDTO.self, router: VideoRouter.fetchVideos(channelId: id, skip: skip, limit: limit))
                
                await tempData.append(contentsOf: videoMapper.dtoToEntity(data.videos, channel: channel, channelID: id))
            }
            return tempData.sorted { $0.updatedAt > $1.updatedAt }
        }
    }
    
#if DEBUG
    deinit {
        print(" DIE TO VIdeoRepository  ")
    }
#endif
    
}

extension VideoRepository: DependencyKey {
    static let liveValue: VideoRepository = VideoRepository()
}

extension DependencyValues {
    var videoRepository: VideoRepository {
        get { self[VideoRepository.self] }
        set { self[VideoRepository.self] = newValue }
    }
}
