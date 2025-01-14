//
//  Photo.swift
//  vkApp
//
//  Created by User on 09/11/2019.
//  Copyright © 2019 一个高兴熊猫. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Photo: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var imageURL: String = ""
    @objc dynamic var bigImageURL: String = ""
    @objc dynamic var isLiked: Bool = false
    @objc dynamic var likesCount: Int = 0
    
    convenience init(ownerId: Int, from json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.ownerId = ownerId
        
        let allSizeImages = json["sizes"].arrayValue
        self.imageURL = allSizeImages
            .filter{ $0["type"].stringValue == "m" }
            .first!["url"].stringValue

        let imageSizeTypes:[String] = allSizeImages.map{ $0["type"].stringValue }
        var bigImageSizeType = ""
        ["w", "z", "y", "x", "m"].forEach{
            if bigImageSizeType == "" && imageSizeTypes.contains($0) {
                bigImageSizeType = $0
            }
        }
        self.bigImageURL = allSizeImages
            .filter{ $0["type"].stringValue == bigImageSizeType }
            .first!["url"].stringValue

        self.isLiked = json["likes"]["user_likes"].intValue > 0 ? true : false
        self.likesCount = json["likes"]["count"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
