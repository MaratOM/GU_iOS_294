//
//  MyGroupsController.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class MyGroupsController: UITableViewController {
    var groups = [
        Group(image: UIImage(named: "UKFlag")!,title: "English lessons"),
        Group(image: UIImage(named: "UKFlag")!,title: "English meetings"),
        Group(image: UIImage(named: "UKFlag")!,title: "English group"),
        Group(image: UIImage(named: "UKFlag")!,title: "English speaking club"),
        Group(image: UIImage(named: "UKFlag")!,title: "English movie club")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.tableView.backgroundView = getBackgroundImage();
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
        
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = UIView()
        cell.groupTitleLabel?.textColor = UIColor.white
        
        cell.groupTitleLabel?.text = groups[indexPath.row].title
        cell.groupImageView?.image = groups[indexPath.row].image
                        
        return cell
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
