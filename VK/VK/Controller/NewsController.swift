//
//  NewsController.swift
//  VK
//
//  Created by Marat Mikaelyan on 14/11/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit
import Kingfisher

class NewsController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    private var networkService = NetworkService()
    var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundView = getBackgroundImage();
        
        networkService.loadNews() { result in
            switch result {
            case let .success(news):
                self.news = news as! [News]
                self.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
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
        cell.newsImageView?.kf.setImage(with: URL(string: news[indexPath.row].imageURL))

        return cell
    }
}
