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
        }
    }
    
    let groups = [
        Group(image: UIImage(named: "UKFlag")!, title: "American English lessons"),
        Group(image: UIImage(named: "UKFlag")!, title: "UK English lessons"),
        Group(image: UIImage(named: "UKFlag")!, title: "English with native speaker"),
        Group(image: UIImage(named: "UKFlag")!, title: "English books club"),
        Group(image: UIImage(named: "UKFlag")!, title: "English games club")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundView = getBackgroundImage();
    }

}

extension AllGroupsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicGroupCell", for: indexPath)
        
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = UIView()
        cell.textLabel?.textColor = UIColor.white
        
        cell.textLabel?.text = groups[indexPath.row].title
        cell.imageView?.image = groups[indexPath.row].image
        
        return cell
    }
        
}
