//
//  News.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class News: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var imageURL: String = ""
    @objc dynamic var title: String = ""
    
    convenience init(from json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.title = json["text"].stringValue
        
        let photos = json["attachments"].arrayValue.filter{ $0["type"] == "photo" }
        let allSizeImages = photos.first!["photo"]["sizes"].arrayValue
        let imageSizeTypes:[String] = allSizeImages.map{ $0["type"].stringValue }
        var bigImageSizeType = ""
        ["w", "z", "y", "x", "m"].forEach{
            if bigImageSizeType == "" && imageSizeTypes.contains($0) {
                bigImageSizeType = $0
            }
        }
        self.imageURL = allSizeImages
            .filter{ $0["type"].stringValue == bigImageSizeType }
            .first!["url"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
