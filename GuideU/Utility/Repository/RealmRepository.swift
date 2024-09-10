//
//  RealmRepository.swift
//  GuideU
//
//  Created by 김진수 on 9/2/24.
//

import Foundation
import RealmSwift
import ComposableArchitecture

final class RealmRepository {
    
    @Dependency(\.searchMapper) var mapper
    @Dependency(\.videoMapper) var videoMapper
    
    private let realm = try! Realm()
    
    func searchCreate(history: String) -> Result<Void, RealmError> {
        do {
            
            try realm.write {
                print("dd", realm.configuration.fileURL)
                realm.create(
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
    
    func videoHistoryCreate(videoData: VideosEntity) -> Result<Void, RealmError> {
        do {
            try checkRealmCount()
            
            try realm.write {
                print("dd", realm.configuration.fileURL)
                
                realm.create(
                    VideoHistoryRequestDTO.self,
                    value: [
                        "identifier": videoData.identifier,
                        "videoURL": videoData.videoURL?.absoluteString,
                        "title": videoData.title,
                        "channelName": videoData.channelName,
                        "thumbnail": videoData.videoImageURL?.absoluteString,
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
        return mapper.requestDTOToString(Array(realm.objects(SearchHistoryRequestDTO.self).sorted(by: \.date, ascending: false)))
    }
    
    func fetchVideoHistory() -> [VideosEntity] {
        return videoMapper.requestDTOToEntity(Array(realm.objects(VideoHistoryRequestDTO.self).sorted(by: \.watchedAt, ascending: false)))
    }
    
    func delete(keyworkd: String) -> Result<Void, RealmError> {
        guard let data = realm.object(ofType: SearchHistoryRequestDTO.self, forPrimaryKey: keyworkd) else {
            return .failure(.deleteFail)
        }
    
        do {
            try realm.write {
                realm.delete(data)
            }
            return .success(())
        } catch {
            return .failure(.deleteFail)
        }
    }
    
    func deleteAll() -> Result<Void, RealmError> {
        let datas = realm.objects(SearchHistoryRequestDTO.self)
        
        do {
            try realm.write {
                realm.delete(datas)
            }
            return .success(())
        } catch {
            return .failure(.deleteFail)
        }
    }
    
}

extension RealmRepository {
    private func checkRealmCount() throws {
        let realmDatas = realm.objects(VideoHistoryRequestDTO.self)
        
        if realmDatas.count == 30 {
            guard let deleteData = realmDatas.sorted(by: \.watchedAt, ascending: true).first else { return }
            
            try realm.write {
                realm.delete(deleteData)
            }
        }
        
    }
}

extension RealmRepository: DependencyKey {
    static var liveValue: RealmRepository = RealmRepository()
}

extension DependencyValues {
    var realmRepository: RealmRepository {
        get { self[RealmRepository.self] }
        set { self[RealmRepository.self] = newValue }
    }
}
