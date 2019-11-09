//
//  FriendsController.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class FriendsController: UITableViewController {
    
    var friends = [Friend]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        friends = [
            Friend(id: "1", image: UIImage(named: "1")!, name: "Jack White", photos: createFriendPhotos(imageName: "1")),
            Friend(id: "2", image: UIImage(named: "2")!, name: "Chris Cornell", photos: createFriendPhotos(imageName: "2")),
            Friend(id: "3", image: UIImage(named: "3")!, name: "Jim Morrison", photos: createFriendPhotos(imageName: "3")),
            Friend(id: "4", image: UIImage(named: "4")!, name: "Nick Cave", photos: createFriendPhotos(imageName: "4")),
            Friend(id: "5", image: UIImage(named: "5")!, name: "Jimi Hendrix", photos: createFriendPhotos(imageName: "5")),
        ]

        self.tableView.backgroundView = getBackgroundImage();
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            preconditionFailure("Can not cast FriendCell")
        }
        
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = UIView()
        cell.friendNameLabel?.textColor = UIColor.white
        
        cell.friendImageView.image = friends[indexPath.row].image
        cell.friendNameLabel.text = friends[indexPath.row].name

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Friend Photos",
            let destinationVC = segue.destination as? PhotosController {
            let indexPath = tableView.indexPathForSelectedRow;
            destinationVC.friend = friends[indexPath!.row]
        }
    }
    
    func createFriendPhotos(imageName: String) -> [Photo] {
        var photos = [Photo]()
        
        for _ in 4...10 {
            photos.append(Photo(image: UIImage(named: imageName)!, isLiked: Bool.random(), likesCount: Int.random(in: 10...100)))
        }
        
        return photos
    }

}
