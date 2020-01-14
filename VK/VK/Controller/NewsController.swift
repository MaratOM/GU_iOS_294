//
//  NewsController.swift
//  VK
//
//  Created by Marat Mikaelyan on 14/11/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class NewsController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    private var networkService = NetworkService()
    private var realmService = RealmService.shared
    private var notificationToken: NotificationToken?

    private lazy var news = try! self.realmService.get(News.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = getBackgroundImage();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkService.loadDataWithRealm(type: News.self)
        
        self.notificationToken = news.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                break
            case .update:
                self.tableView.reloadData()
            case let .error(error):
                print(error)
            }
        })
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

        let newsItem = news[indexPath.row]
        cell.id = newsItem.id
        cell.ownerId = newsItem.ownerId
        cell.newsTitleLabel.text = newsItem.title
        cell.newsImageView?.kf.setImage(with: URL(string: newsItem.imageURL))
        cell.isLiked = newsItem.isLiked
        cell.likesCount = newsItem.likesCount
        
        return cell
    }
}
