//
//  Friend.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Friend: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var imageURL: String = ""
    @objc dynamic var name: String = ""
    var photos: [Photo] = []
    
    convenience init?(from json: JSON) {
        self.init()
        
        guard json["first_name"].stringValue != "DELETED" else { return nil }
        
        self.id = json["id"].intValue
        self.name = json["first_name"].stringValue + " " + json["last_name"].stringValue
        self.imageURL = json["photo_100"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    public func setPhotos(_ photos: [Photo]) {
        self.photos = photos
    }
}
