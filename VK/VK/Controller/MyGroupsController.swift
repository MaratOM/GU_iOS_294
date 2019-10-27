//
//  MyGroupsController.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class MyGroupsController: UITableViewController {
    let groups = [
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
