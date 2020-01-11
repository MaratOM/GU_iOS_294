//
//  MyGroupsController.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class MyGroupsController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    var groups = [
        Group(image: UIImage(named: "UKFlag")!,title: "English lessons"),
        Group(image: UIImage(named: "UKFlag")!,title: "English meetings")
    ]
    
    var filteredGroups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.tableView.backgroundView = getBackgroundImage()
        
//        NetworkService.loadGroups(callback: getVKData)
        
        filteredGroups = groups
    }
    
    func getVKData (_ json: String) {
        print(#function)
        print(json)
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
        
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = UIView()
        cell.groupTitleLabel?.textColor = UIColor.white
        
        cell.groupTitleLabel?.text = filteredGroups[indexPath.row].title
        cell.groupImageView?.image = filteredGroups[indexPath.row].image
                        
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
