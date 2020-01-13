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
    private var notificationToken: NotificationToken?

    private var realmObjects: Results<Group>!
    private var groups = [Group]()
    private var filteredGroups = [Group]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.tableView.backgroundView = getBackgroundImage()
    
//        guard let realm = try? Realm() else { fatalError() }
//        try? realm.write {
//            realm.deleteAll()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let updatedTime = try! realmService.get(Update.self).filter("dataType == %@", "groups").first?.timeStamp
        print("groups time diff \(NSDate().timeIntervalSince1970 - Double(updatedTime ?? NSDate().timeIntervalSince1970))")
        
        realmObjects = try! realmService.get(Group.self)
        
        if (realmObjects.count == 0 || NSDate().timeIntervalSince1970 - Double(updatedTime!) > Update.interval) {
            networkService.loadGroups() { result in
                switch result {
                case let .success(groups):
                    print("groups got from api")
                    
                    try! self.realmService.save(groups)
                    self.realmObjects = try! self.realmService.get(Group.self)
                    let updateTime = Update(dataType: "groups", timeStamp: NSDate().timeIntervalSince1970)
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
                addGroupAlert(group: group)
            } else {
                groupExistsAlert(group)
            }
        }
    }
    
    @IBAction func addGroupAlert(group: Group) {
        let alertController = UIAlertController(title: "Добваление группы", message: "Вступить в группу\n\(group.title)", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel) { _ in return }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Да", style: .default) { (action:UIAlertAction!) in
            self.networkService.joinGroup(id: group.id)

            try! self.realmService.save([group])
            self.initData()
            
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func groupExistsAlert(_ group: Group) {
        let alertController = UIAlertController(title: "Добваление группы", message: "Вы уже являетесь членом группы\n\(group.title)", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Ok", style: .default) { _ in return }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
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
