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
    private var realmService = RealmService()
    private var notificationToken: NotificationToken?

    private var realmObjects: Results<Photo>!
    private var photos = [Photo]()
    public var friend: Friend? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.backgroundView = getBackgroundImage();
        self.title = friend?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let updatedTime = try! realmService.get(Update.self).filter("dataType == %@", "photos").first?.timeStamp
        print("photos time diff \(NSDate().timeIntervalSince1970 - Double(updatedTime ?? NSDate().timeIntervalSince1970))")
        
        realmObjects = try! realmService.get(Photo.self).filter("ownerId = %i", friend!.id)
        
        if (realmObjects.count == 0 || NSDate().timeIntervalSince1970 - Double(updatedTime!) > Update.interval) {
            networkService.loadPhotos(ownerId: friend!.id) { result in
                switch result {
                case let .success(photos):
                    print("photos got from api")
                    
                    try! self.realmService.save(photos)
                    self.realmObjects = try! self.realmService.get(Photo.self)
                    let updateTime = Update(dataType: "photos", timeStamp: NSDate().timeIntervalSince1970)
                    try! self.realmService.save([updateTime])
                    self.initData()
                case let .failure(error):
                    print(error)
                }
            }
        } else {
            initData()
        }
        
        self.notificationToken = realmObjects.observe({ [weak self] change in
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
    
    private func initData() {
        self.photos = Array(realmObjects)
        self.collectionView.reloadData()
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
            destinationVC.photos = photos
            destinationVC.selectedPhotoIndex = indexPath!.item
            collectionView.deselectItem(at: indexPath!, animated: true)
        }
    }

}
