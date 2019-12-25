//
//  AllGroupsControllerViewController.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class AllGroupsController: UIViewController {

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    let allGroups: [Group] = [
//        Group(image: UIImage(named: "UKFlag")!, title: "American English lessons"),
//        Group(image: UIImage(named: "UKFlag")!, title: "UK English lessons"),
//        Group(image: UIImage(named: "UKFlag")!, title: "English with native speaker"),
//        Group(image: UIImage(named: "UKFlag")!, title: "English books club"),
//        Group(image: UIImage(named: "UKFlag")!, title: "English games club"),
//        Group(image: UIImage(named: "UKFlag")!,title: "English speaking club"),
//        Group(image: UIImage(named: "UKFlag")!,title: "English movie club")
    ]
    
    var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groups = allGroups
        self.tableView.backgroundView = getBackgroundImage();
    }

}

extension AllGroupsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicGroupCell", for: indexPath)
        
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = UIView()
        cell.textLabel?.textColor = UIColor.white
        
        cell.textLabel?.text = groups[indexPath.row].title
//        cell.imageView? = groups[indexPath.row].image!
        
        return cell
    }
}

extension AllGroupsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            groups = allGroups
        } else {
            groups = groups.filter({ $0.title.lowercased().contains(searchText.lowercased()) })
        }
        
        tableView.reloadData()
        print(searchText)
    }
}
