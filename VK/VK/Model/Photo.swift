//
//  Photo.swift
//  vkApp
//
//  Created by User on 09/11/2019.
//  Copyright © 2019 一个高兴熊猫. All rights reserved.
//

import UIKit
import SwiftyJSON

class Photo {
    var id: Int
    var imageURL: String
    var isLiked: Bool
    var likesCount: Int
    
    init(from json: JSON) {
        self.id = json["id"].intValue
        // remove lets
//        let imageSizes = json["sizes"].arrayValue
//        let wSizeImage = imageSizes.filter{ $0["type"] == "m" }.first
//        self.imageURL = wSizeImage!["url"].stringValue
        
        self.imageURL = json["sizes"].arrayValue
            .filter{ $0["type"] == "m" }
            .first!["url"].stringValue
        
        self.isLiked = json["likes"]["user_likes"].intValue > 0 ? true : false
        self.likesCount = json["likes"]["count"].intValue
    }
}
