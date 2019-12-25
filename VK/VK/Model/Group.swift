//
//  Group.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import Foundation
import SwiftyJSON

class Group {
    let id: Int
    let imageURL: String
    let title: String
    
    init(from json: JSON) {
        self.id = json["id"].intValue
        self.title = json["name"].stringValue
        self.imageURL = json["photo_100"].stringValue
    }
}
