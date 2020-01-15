//
//  PhotosController.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class PhotosController: UICollectionViewController {

    private var networkService = NetworkService()
    private var realmService = RealmService.shared
    private var notificationToken: NotificationToken?

    private lazy var photos = try! realmService.get(Photo.self).filter("ownerId = %i", friend!.id)
    public var friend: Friend? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundView = getBackgroundImage();
        title = friend?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkService.loadDataWithRealm(type: Photo.self, additionalData: ["ownerId": friend!.id])
        
        self.notificationToken = photos.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case .update:
                self.collectionView.reloadData()
            case let .error(error):
                print(error)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        notificationToken?.invalidate()
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
            destinationVC.photos = Array(photos)
            destinationVC.selectedPhotoIndex = indexPath!.item
            collectionView.deselectItem(at: indexPath!, animated: true)
        }
    }

}
