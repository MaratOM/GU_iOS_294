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
    
    private var networkService = NetworkService()
    private var allFriends = [Friend]()
    private var friends = [Friend]()
    private var friendsDict = [Character: [Friend]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundView = getBackgroundImage();
        
//        networkService.loadFriends() { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case let .success(friends):
//                self.allFriends = friends as! [Friend]
//                self.friends = self.allFriends
//                self.friendsDict = self.sort(friends: friends as! [Friend])
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
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
        
        cell.configure(with: friend)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Friend Photos",
            let destinationVC = segue.destination as? PhotosController {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let char = friendsDict.keys.sorted()[indexPath.section]
            let friend = friendsDict[char]![indexPath.row]
            destinationVC.friend = friend
        }
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
