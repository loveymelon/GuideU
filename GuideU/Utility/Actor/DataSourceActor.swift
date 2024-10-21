//
//  DataSourceActor.swift
//  GuideU
//
//  Created by 김진수 on 9/2/24.
//

import Foundation
import RealmSwift

final actor DataSourceActor {
    
    private var realm: Realm?
    
    private let mapper: SearchMapper
    private let videoMapper: VideoMapper
    
    init() {
        self.mapper = SearchMapper()
        self.videoMapper = VideoMapper()
        Task {
            await self.setup()
        }
    }
    
    private func setup() async { // 내쓰레드
        do {
            realm = try await Realm.open()
        } catch {
            realm = nil
        }
    }
    
    func searchCreate(history: String) async throws(RealmError) -> Void {
        do {
            
            try await realm?.asyncWrite {
                #if DEBUG
                print("realm", realm?.configuration.fileURL ?? "")
                #endif
                realm?.create(
                    SearchHistoryRequestDTO.self,
                    value: [
                        "history": history,
                        "date": Date()
                    ],
                    update: .modified)
            }
            
            return ()
            
        } catch {
            throw .createFail
        }
    }
    
    func videoHistoryCreate(videoData: VideosEntity) async throws(RealmError) -> Void {
        do {
            try await checkRealmCount()
            
            try await realm?.asyncWrite {
                print("realm", realm?.configuration.fileURL ?? "")
                
                realm?.create(
                    VideoHistoryRequestDTO.self,
                    value: [
                        "identifier": videoData.identifier,
                        "videoURL": videoData.videoURL?.absoluteString ?? "",
                        "title": videoData.title,
                        "channelName": videoData.channelName,
                        "channelImage": videoData.channelImageURL?.absoluteString ?? "",
                        "thumbnail": videoData.videoImageURL?.absoluteString ?? "",
                        "updatedAt": videoData.updatedAt,
                        "watchedAt": Date()
                    ],
                    update: .modified
                )
            }
            return ()
        } catch {
            throw .createFail
        }
    }
    
    func fetch() -> [String] {
        guard let realm else { return [] }
        
        let searchDatas = mapper.requestDTOToString(Array(realm.objects(SearchHistoryRequestDTO.self).sorted(by: \.date, ascending: false)))
        
        if searchDatas.count > 5 {
            return Array(searchDatas.prefix(5))
        } else {
            return searchDatas
        }
    }
    
    func fetchVideoHistory() -> [HistoryVideosEntity] {
        guard let realm else { return [] }
        
        let realmData = Array(realm.objects(VideoHistoryRequestDTO.self).sorted(by: \.watchedAt, ascending: false))
        
        let mapping = videoMapper.dtoToEntity(dtos: realmData)
        
        return mapping
    }
    
    func delete(keyworkd: String) async throws(RealmError) -> Void {
        guard let realm else { throw .deleteFail }
        
        guard let data = realm.object(ofType: SearchHistoryRequestDTO.self, forPrimaryKey: keyworkd) else {
            throw .deleteFail
        }
    
        do {
            try await realm.asyncWrite {
                realm.delete(data)
            }
            return ()
        } catch {
            throw .deleteFail
        }
    }
    
    func deleteAll() async throws(RealmError) -> Void {
        guard let realm else { throw .deleteFail }
        let datas = realm.objects(SearchHistoryRequestDTO.self)
        
        do {
            try await realm.asyncWrite {
                realm.delete(datas)
            }
            return ()
        } catch {
            throw .deleteFail
        }
    }
    
}

extension DataSourceActor {
    private func checkRealmCount() async throws(RealmError) {
        guard let realm else { throw .unknownError }
        
        let realmDatas = realm.objects(VideoHistoryRequestDTO.self)
        
        do {
            if realmDatas.count == 30 {
                guard let deleteData = realmDatas.sorted(by: \.watchedAt, ascending: true).first else { return }
                
                try await realm.asyncWrite {
                    realm.delete(deleteData)
                }
            }
        } catch {
            throw .unknownError
        }
    }
}
