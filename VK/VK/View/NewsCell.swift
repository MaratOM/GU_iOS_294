//
//  NewsCell.swift
//  VK
//
//  Created by Marat Mikaelyan on 14/11/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet var newsTitleLabel: UILabel!
    @IBOutlet var newsImageView: UIImageView!
    
    @IBOutlet var likeImageView: UIImageView!
    @IBOutlet var likeCountLabel: UILabel!
    
    private var networkService = NetworkService()

    let imageOnName = "heart.fill"
    let imageOffName = "heart"
    
    var likeImageName = "" {
        didSet {
            if #available(iOS 13.0, *) {
                likeImageView.image = UIImage(systemName: likeImageName)
            } else {
                // Fallback on earlier versions
            }
        }
    }

    var isLiked: Bool = false {
        didSet {
            if (isLiked) {
                likeImageName = imageOnName
            } else {
                likeImageName = imageOffName
            }
        }
    }
    var likesCount = 0 {
        didSet {
            likeCountLabel!.text = String(likesCount)
        }
    }
    
    var id = 1
    var ownerId = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        likeImageView.tintColor = .red
        
        if #available(iOS 13.0, *) {
            setGestureRecognizer()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 13.0, *)
    func setGestureRecognizer() {
        let gr: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeTapped(_:)))
        gr.numberOfTapsRequired = 1
        likeImageView.addGestureRecognizer(gr)
    }
    
    @available(iOS 13.0, *)
    @objc private func likeTapped(_ tapGesture: UITapGestureRecognizer) {
        isLiked.toggle()
        setNeedsDisplay()
        
        if isLiked {
            likesCount += 1
            networkService.addLike(type: "post", ownerId: self.ownerId, id: self.id)
        } else {
            likesCount -= 1
            networkService.deleteLike(type: "post", ownerId: self.ownerId, id: self.id)
        }

    }
}
