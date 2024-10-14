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
    
    func fetchVideoHeader(identifier: String) async -> Result<(header: HeaderEntity, video: VideosEntity)?, String> {
        let result = await network.requestNetwork(dto: VideoDTO.self, router: VideoRouter.fetchVideos(identifier: identifier))
        
        switch result {
        case .success(let data):
            guard let headerData = videoMapper.dtoToEntityToHeader(data.videos).first,
                  let videoData = videoMapper.dtoToEntity(data.videos).first else {
                return .success(nil)
            }
            return .success((headerData, videoData))
        case .failure(let error):
            return .failure(catchError(error))
        }
    }
    
    func fetchVideos(channel: Const.Channel, skip: Int = 0, limit: Int = 10) async -> Result<[VideosEntity], String> {
        var tempData: [VideosEntity] = []
        
        if channel.channelIDs.isEmpty {
            let result = await network.requestNetwork(dto: VideoDTO.self, router: VideoRouter.fetchVideos(skip: skip, limit: limit))
            
            switch result {
            case .success(let data):
                return .success(videoMapper.dtoToEntity(data.videos, channel: channel))
            case .failure(let error):
                return .failure(catchError(error))
            }
        } else {
            for id in channel.channelIDs {
                let result = await network.requestNetwork(dto: VideoDTO.self, router: VideoRouter.fetchVideos(channelId: id, skip: skip, limit: limit))
                
                switch result {
                case .success(let data):
                    tempData.append(contentsOf: videoMapper.dtoToEntity(data.videos, channel: channel, channelID: id))
                case .failure(let error):
                    return .failure(catchError(error))
                }
            }
        }
        
        return .success(tempData.sorted { $0.updatedAt > $1.updatedAt })
    }
}

extension VideoRepository {
    private func catchError(_ error: APIErrorResponse) -> String {
        switch error {
            
        case let .simple(simpleError):
            return errorMapper.dtoToEntity(simpleError)
        case let .detailed(detailError):
            return errorMapper.dtoToEntity(detailError)
        }
    }
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
