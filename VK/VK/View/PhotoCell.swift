//
//  PhotoCell.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var likeControl: LikeControlPath!
    
    // MARK - Public API
    public func configureLikeControl(likes count: Int, isLikedByUser: Bool) {
        likeControl.configure(likes: count, isLikedByUser: isLikedByUser)
    }

}
