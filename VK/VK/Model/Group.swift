//
//  Group.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class Group {
    let image: UIImage?
    let title: String
    
    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
    
    init(title: String) {
        self.title = title
        self.image = nil
    }
    
}
