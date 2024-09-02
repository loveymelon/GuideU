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
    
    private let realm = try! Realm()
    
    func create(history: String) -> Result<Void, RealmError> {
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
    
    func fetch() -> [String] {
        return mapper.requestDTOToString(Array(realm.objects(SearchHistoryRequestDTO.self).sorted(by: \.date, ascending: false)))
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

extension RealmRepository: DependencyKey {
    static var liveValue: RealmRepository = RealmRepository()
}

extension DependencyValues {
    var realmRepository: RealmRepository {
        get { self[RealmRepository.self] }
        set { self[RealmRepository.self] = newValue }
    }
}
