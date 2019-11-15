//
//  NewsController.swift
//  VK
//
//  Created by Marat Mikaelyan on 14/11/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class NewsController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
        
    let news: [News] = [
        News(id: "1", image: UIImage(named: "news1")!, title: "Jack White"),
        News(id: "2", image: UIImage(named: "news3")!, title: "Chris Cornell")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundView = getBackgroundImage();
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else { preconditionFailure("Can not cast NewsCell") }
        
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = UIView()
        cell.newsTitleLabel?.textColor = UIColor.white

        cell.newsTitleLabel.text = news[indexPath.row].title
        cell.newsImageView.image = news[indexPath.row].image
        
        return cell
    }
}
