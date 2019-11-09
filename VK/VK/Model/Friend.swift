//
//  Friend.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class Friend {
    let id: String
    let image: UIImage
    let name: String
    let photos: [Photo]
    
    init(id: String, image: UIImage, name: String, photos: [Photo] = []) {
        self.id = id
        self.image = image
        self.name = name
        self.photos = photos
    }
}
