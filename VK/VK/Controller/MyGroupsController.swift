//
//  MyGroupsController.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupsController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    private var networkService = NetworkService()
    private var realmService = RealmService()
    private var groups = [Group]()
    private var realmObjects: Results<Group>!
    private var filteredGroups = [Group]()
    private var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.tableView.backgroundView = getBackgroundImage()
        
        realmObjects = try! realmService.get(Group.self)

                
//        guard let realm = try? Realm() else { fatalError() }
//        try? realm.write {
//            realm.deleteAll()
//        }
        
        if (realmObjects.count == 0) {
            networkService.loadGroups() { result in
                switch result {
                case let .success(groups):
                    try! self.realmService.save(groups)
                    self.realmObjects = try! self.realmService.get(Group.self)
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
            case let .update(results, deletions, insertions, modifications):
                self.tableView.reloadData()
            case let .error(error):
                print(error)
            }
        })
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    private func initData() {
        self.groups = Array(realmObjects)
        self.filteredGroups = self.groups
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell else {
            preconditionFailure("Cell can not be dequeued")
        }

        cell.configure(with: filteredGroups[indexPath.row])
                        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    @IBAction func addSelectedGroup(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? AllGroupsController,
            let indexPath = sourceVC.tableView.indexPathForSelectedRow {
            let group = sourceVC.groups[indexPath.row]
            if !groups.contains(where: {$0.title == group.title}) {
                groups.append(group)
                tableView.reloadData()
            }
        }
    }

}

extension MyGroupsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredGroups = groups
        } else {
            filteredGroups = groups.filter({ $0.title.lowercased().contains(searchText.lowercased()) })
        }
        
        tableView.reloadData()
        print(searchText)
    }
}
