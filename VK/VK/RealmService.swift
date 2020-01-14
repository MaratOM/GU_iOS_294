//
//  RealmService.swift
//  VK
//
//  Created by Marat Mikaelyan on 02/01/2020.
//  Copyright © 2020 maratom. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    var realm: Realm
    let realmConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    let updateType: Realm.UpdatePolicy = .all
    
    private init() {
        self.realm = try! Realm(configuration: self.realmConfiguration)
        
        print(self.realmConfiguration.fileURL ?? "")
    }
    
    static let shared = RealmService()
    
    func get<T: Object>(_ type: T.Type) throws -> Results<T>{
        return realm.objects(type)
    }
    
    func save<T: Object>(_ items: [T]) throws {
        try realm.write {
            realm.add(items, update: updateType)
        }
    }
    
    func delete<T: Object>(_ items: [T]) throws {
        try realm.write {
            realm.delete(items)
        }
    }
    
    func deleteAll() throws {
        try realm.write {
            realm.deleteAll()
        }
    }
}
