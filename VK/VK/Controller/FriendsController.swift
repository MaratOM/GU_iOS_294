//
//  FriendsController.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class FriendsController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    var allFriends = [Friend]()
    var friends = [Friend]()
    var friendsDict = [Character: [Friend]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        allFriends = [
            Friend(id: "1", image: UIImage(named: "1")!, name: "Jack White", photos: createFriendPhotos(imageName: "1")),
            Friend(id: "2", image: UIImage(named: "2")!, name: "Chris Cornell", photos: createFriendPhotos(imageName: "2")),
            Friend(id: "3", image: UIImage(named: "3")!, name: "Jim Morrison", photos: createFriendPhotos(imageName: "3")),
            Friend(id: "4", image: UIImage(named: "4")!, name: "Nick Cave", photos: createFriendPhotos(imageName: "4")),
            Friend(id: "5", image: UIImage(named: "5")!, name: "Jimi Hendrix", photos: createFriendPhotos(imageName: "5")),
        ]
        
        friends = allFriends
        friendsDict = sort(friends: friends)

        self.tableView.backgroundView = getBackgroundImage();
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsDict.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let char = friendsDict.keys.sorted()[section]

        return friendsDict[char]!.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.2)
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return String(friendsDict.keys.sorted()[section])
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            preconditionFailure("Can not cast FriendCell")
        }
        
        let char = friendsDict.keys.sorted()[indexPath.section]
        let friend = friendsDict[char]![indexPath.row]
        
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = UIView()
        cell.friendNameLabel?.textColor = UIColor.white
        
        cell.friendImageView.image = friend.image
        cell.friendNameLabel.text = friend.name

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
    
    private func sort(friends: [Friend]) -> [Character: [Friend]]{
        var friendsDict = [Character: [Friend]]()
        
        friends.sorted{ $0.name < $1.name }.forEach{ friend in
            guard let firstLetter = friend.name.first else { return }
            
            if friendsDict.keys.contains(firstLetter) {
                friendsDict[firstLetter]?.append(friend)
            } else {
                friendsDict[firstLetter] = [friend]
            }
        }
        
        return friendsDict
    }

}

extension FriendsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            friends = allFriends
        } else {
            friends = allFriends.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        }
        friendsDict = sort(friends: friends)

        tableView.reloadData()
        print(searchText)
    }
}
