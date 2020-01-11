//
//  PhotoCell.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var likeControl: LikeControlPath!
        
    // MARK - Public API
    public func configure(with photo: Photo) {
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        photoImageView.kf.setImage(with: URL(string: photo.imageURL))
                
        likeControl.configure(photo: photo)
    }
}
