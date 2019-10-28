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
    
    override func viewWillAppear(_ animated: Bool) {
        assignbackground()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        
        cell.groupTitleLabel?.text = groups[indexPath.row].title
        cell.groupImageView?.image = groups[indexPath.row].image
                
        cell.groupTitleLabel?.textColor = UIColor.white
        
        cell.backgroundColor = .clear
        cell.backgroundView = UIView()
        cell.selectedBackgroundView = UIView()

        return cell
    }
    
    func assignbackground(){
          let background = UIImage(named: "vk_bg")

          var imageView : UIImageView!
          imageView = UIImageView(frame: view.bounds)
//          imageView.contentMode =  UIViewContentMode.ScaleAspectFill
          imageView.clipsToBounds = true
          imageView.image = background
          imageView.center = view.center
//          view.addSubview(imageView)
//          self.view.sendSubviewToBack(imageView)
//          self.view.insertSubview(imageView, at: 0)
        self.tableView.backgroundView = imageView;
      }

    
    @IBAction func addSelectedGroup(segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? AllGroupsController,
            let indexPath = sourceVC.tableView.indexPathForSelectedRow {
            let group = sourceVC.groups[indexPath.row]
            groups.append(group)
            tableView.reloadData()
        }
    }

}
