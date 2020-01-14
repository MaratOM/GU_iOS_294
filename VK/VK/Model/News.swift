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
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var imageURL: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var isLiked: Bool = false
    @objc dynamic var likesCount: Int = 0
    
    convenience init?(from json: JSON) {
        self.init()
        
        let photos = json["attachments"].arrayValue.filter{ $0["type"] == "photo" }

        guard photos.count > 0 else { return nil }
        
        self.id = json["id"].intValue
        self.ownerId = json["owner_id"].intValue
        self.title = json["text"].stringValue
        
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
        
        self.isLiked = json["likes"]["user_likes"].intValue > 0 ? true : false
        self.likesCount = json["likes"]["count"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
