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

    private lazy var groups = try! self.realmService.get(Group.self)
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.tableView.backgroundView = getBackgroundImage()
    
//        try! self.realmService.deleteAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkService.loadDataWithRealm(type: Group.self)
        
        self.notificationToken = groups.observe({ [weak self] change in
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell else {
            preconditionFailure("Cell can not be dequeued")
        }

        cell.configure(with: groups[indexPath.row])
                        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let group = groups[indexPath.row]
            self.networkService.leaveGroup(id: group.id)
            try! self.realmService.delete([group])
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
            self.groups = try! self.realmService.get(Group.self)
        } else {
            self.groups = try! self.realmService.get(Group.self).filter("title CONTAINS[cd] %@", searchText)
        }
        
        tableView.reloadData()
    }
}
