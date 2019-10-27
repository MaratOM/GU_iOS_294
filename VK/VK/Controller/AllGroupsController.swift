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
        
        assignbackground()

        // Do any additional setup after loading the view.
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

}

extension AllGroupsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicGroupCell", for: indexPath)
        
        cell.textLabel?.text = groups[indexPath.row].title
        cell.imageView?.image = groups[indexPath.row].image
        
        cell.textLabel?.textColor = UIColor.white

        cell.backgroundColor = .clear
        cell.backgroundView = UIView()
        cell.selectedBackgroundView = UIView()

        return cell
    }
        
}
