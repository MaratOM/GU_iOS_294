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
        return Int.random(in: 5 ... 10)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            preconditionFailure()
        }
        
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = UIView()

        cell.photoImageView.image = UIImage(named: friend!.id)
    
        return cell
    }

}
