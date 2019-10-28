//
//  FriendsController.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class FriendsController: UITableViewController {
    
    let friends = [
        Friend(id: 1, image: UIImage(named: "UKFlag")!, name: "Jim Mirrison"),
        Friend(id: 2, image: UIImage(named: "UKFlag")!, name: "Nick Cave"),
        Friend(id: 3, image: UIImage(named: "UKFlag")!, name: "Chris Cornell"),
        Friend(id: 4, image: UIImage(named: "UKFlag")!, name: "Jack White"),
        Friend(id: 5, image: UIImage(named: "UKFlag")!, name: "Jimi Hendrix"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        cell.friendImageView.image = friends[indexPath.row].image
        cell.friendNameLabel.text = friends[indexPath.row].name

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Friend Photos",
            let destinationVC = segue.destination as? PhotosController {
            let indexPath = tableView.indexPathForSelectedRow;
            destinationVC.title = friends[indexPath!.row].name
        }
    }

}
