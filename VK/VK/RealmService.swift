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
    static let realmConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    static func get<T: Object>(_ type: T.Type,
        configuration: Realm.Configuration = realmConfiguration,
        update: Realm.UpdatePolicy = .all) throws -> Results<T>{
        let realm = try Realm(configuration: configuration)
        return realm.objects(type)
    }
    
    static func save<T: Object>(_ items: [T],
        configuration: Realm.Configuration = realmConfiguration,
        update: Realm.UpdatePolicy = .all) throws {
        let realm = try Realm(configuration: configuration)
        
        print(configuration.fileURL ?? "")
        
        try realm.write {
            realm.add(items, update: update)
        }
    }
}
