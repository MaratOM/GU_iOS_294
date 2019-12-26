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

    private var networkService = NetworkService()
    private var photos = [Photo]()
    public var friend: Friend? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.backgroundView = getBackgroundImage();
        self.title = friend?.name
        
        networkService.loadPhotos(ownerId: friend!.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(photos):
                self.photos = photos as! [Photo]
                print(self.photos.first!.imageURL)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            preconditionFailure()
        }
        
        cell.configure(with: photos[indexPath.row])
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Big Photo",
            let destinationVC = segue.destination as? BigPhotoController {
            let indexPath = collectionView.indexPathsForSelectedItems?.first;
            destinationVC.photos = friend!.photos
            destinationVC.selectedPhotoIndex = indexPath!.item
            collectionView.deselectItem(at: indexPath!, animated: true)
        }
    }

}
