//
//  Photo.swift
//  vkApp
//
//  Created by User on 09/11/2019.
//  Copyright © 2019 一个高兴熊猫. All rights reserved.
//

import UIKit

class Photo {
    var image: UIImage
    var isLiked: Bool
    var likesCount: Int
    
    init(image: UIImage, isLiked: Bool, likesCount: Int) {
        self.image = image
        self.isLiked = isLiked
        self.likesCount = likesCount
    }
}
