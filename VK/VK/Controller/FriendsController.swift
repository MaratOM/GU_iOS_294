//
//  FriendsController.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    private var networkService = NetworkService()
    private var realmService = RealmService.shared
    private var notificationToken: NotificationToken?

    private lazy var friends = try! self.realmService.get(Friend.self)
    private lazy var friendsDict = [Character: Results<Friend>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundView = getBackgroundImage();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkService.loadDataWithRealm(type: Friend.self)

        self.populateFriendsDict(with: friends)
        self.tableView.reloadData()
        
        self.notificationToken = friends.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case .update:
                self.tableView.reloadData()
            case let .error(error):
                print(error)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        notificationToken?.invalidate()
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

    private func populateFriendsDict(with friends: Results<Friend>) {
        var firstLetters = Set<Character>()
        self.friendsDict = [Character: Results<Friend>]()
        
        friends.sorted{ $0.lastName < $1.lastName }.forEach{ firstLetters.insert($0.lastName.first!) }
        
        firstLetters.forEach{ char in
            friendsDict[char] = friends.filter("lastName BEGINSWITH %@", String(char))
        }
    }
}

extension FriendsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.friends = try! self.realmService.get(Friend.self)
        } else {
            self.friends = try! self.realmService.get(Friend.self).filter("name CONTAINS[cd] %@", searchText)
        }
                
        populateFriendsDict(with: friends)
        tableView.reloadData()
    }
}
