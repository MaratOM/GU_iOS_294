//
//  AllGroupsControllerViewController.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit
import Kingfisher

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
            searchBar.placeholder = "Введите данные для поиска"
        }
    }
    
    private var networkService = NetworkService()
    public var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = getBackgroundImage();
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
        cell.imageView?.kf.setImage(with: URL(string: groups[indexPath.row].imageURL))

        return cell
    }
}

extension AllGroupsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            groups = []
        } else {
            networkService.searchGroups(q: searchText) { result in
                switch result {
                case let .success(groups):
                    self.groups = groups as! [Group]
                    self.tableView.reloadData()
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}
