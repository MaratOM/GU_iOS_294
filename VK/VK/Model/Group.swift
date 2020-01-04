//
//  Group.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var imageURL: String = ""
    @objc dynamic var title: String = ""
    
    convenience init(from json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.title = json["name"].stringValue
        self.imageURL = json["photo_100"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return []
    }
}
