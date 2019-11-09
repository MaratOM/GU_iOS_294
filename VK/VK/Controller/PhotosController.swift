//
//  PhotosController.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotosController: UICollectionViewController {

    public var friend: Friend? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.backgroundView = getBackgroundImage();
        self.title = friend?.name

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (friend?.photos.count)!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            preconditionFailure()
        }
        
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = UIView()

        cell.photoImageView.image = friend?.photos[indexPath.row].image
        
        cell.configureLikeControl(likes: (friend?.photos[indexPath.row].likesCount)!, isLikedByUser: (friend?.photos[indexPath.row].isLiked)!)
    
        return cell
    }

}
