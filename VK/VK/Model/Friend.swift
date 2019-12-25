//
//  Friend.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit
import SwiftyJSON

class Friend {
    let id: Int
    let imageURL: String
    let name: String
    let photos: [Photo]
    
    init(from json: JSON) {
        self.id = json["id"].intValue
        self.name = json["first_name"].stringValue + " " + json["last_name"].stringValue
        self.imageURL = json["photo_100"].stringValue
        self.photos = []
    }
}
