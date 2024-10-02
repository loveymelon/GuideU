//
//  RealmRepository.swift
//  GuideU
//
//  Created by 김진수 on 9/2/24.
//

import Foundation
import RealmSwift

final actor RealmRepository {
    
    private var realm: Realm?
    
    private let mapper: SearchMapper
    private let videoMapper: VideoMapper
    
    init() { // None Async
        self.mapper = SearchMapper()
        self.videoMapper = VideoMapper()
        Task { // 타쓰레드
            /*
             do {
                 self.realm = try await Realm.open()
             } catch {
                 realm = nil
             }
             */
            await self.setup() // 타쓰레드가 내쓰레드 쓰는 함수 호출
        }
        
    }
    
    private func setup() async { // 내쓰레드
        do {
            realm = try await Realm.open()
        } catch {
            realm = nil
        }
    }
    
    func searchCreate(history: String) async -> Result<Void, RealmError> {
        do {
            
            try await realm?.asyncWrite {
//                #if DEBUG
                print("dd", realm?.configuration.fileURL)
//                #endif
                realm?.create(
                    SearchHistoryRequestDTO.self,
                    value: [
                        "history": history,
                        "date": Date()
                    ],
                    update: .modified)
            }
            
            return .success(())
            
        } catch {
            return .failure(.createFail)
        }
    }
    
    func videoHistoryCreate(videoData: VideosEntity) async -> Result<Void, RealmError> {
        do {
            try await checkRealmCount()
            
            try await realm?.asyncWrite {
                print("dd", realm?.configuration.fileURL)
                
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
            return .success(())
        } catch {
            return .failure(.createFail)
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
    
    func delete(keyworkd: String) async -> Result<Void, RealmError> {
        guard let realm else { return .failure(.deleteFail) }
        
        guard let data = realm.object(ofType: SearchHistoryRequestDTO.self, forPrimaryKey: keyworkd) else {
            return .failure(.deleteFail)
        }
    
        do {
            try await realm.asyncWrite {
                realm.delete(data)
            }
            return .success(())
        } catch {
            return .failure(.deleteFail)
        }
    }
    
    func deleteAll() async -> Result<Void, RealmError> {
        guard let realm else { return .failure(.deleteFail) }
        let datas = realm.objects(SearchHistoryRequestDTO.self)
        
        do {
            try await realm.asyncWrite {
                realm.delete(datas)
            }
            return .success(())
        } catch {
            return .failure(.deleteFail)
        }
    }
    
}

extension RealmRepository {
    private func checkRealmCount() async throws {
        guard let realm else { throw RealmError.unknownError }
        
        let realmDatas = realm.objects(VideoHistoryRequestDTO.self)
        
        if realmDatas.count == 30 {
            guard let deleteData = realmDatas.sorted(by: \.watchedAt, ascending: true).first else { return }
            
            try await realm.asyncWrite {
                realm.delete(deleteData)
            }
        }
    }
}
