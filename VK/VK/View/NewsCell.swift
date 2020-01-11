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
    
    var isLiked: Bool = false
    var likesCount = 0
    var likeImageName = "heart"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeCountLabel!.text = String(likesCount)
        
        if #available(iOS 13.0, *) {
            likeImageView.image = UIImage(systemName: likeImageName)
        } else {
            // Fallback on earlier versions
        }
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
        tapped(&isLiked,  likeCountLabel, &likesCount, likeImageView, &likeImageName, "heart.fill", "heart")
    }
    
    @available(iOS 13.0, *)
    private func tapped( _ toggled: inout Bool, _ countLabel: UILabel, _ count: inout Int, _ imageView: UIImageView, _ imageName: inout String, _ imageOnName: String, _ imageOffName: String) {
        
        toggled.toggle()
        setNeedsDisplay()

        if toggled {
            count += 1
            countLabel.text = String(count)
            imageName = imageOnName
            imageView.image = UIImage(systemName: imageName)
        } else {
            count -= 1
            countLabel.text = String(count)
            imageName = imageOffName
            imageView.image = UIImage(systemName: imageName)
        }
    }
    
        @available(iOS 13.0, *)
        @objc private func likeTapped_(_ tapGesture: UITapGestureRecognizer) {
            isLiked.toggle()
            setNeedsDisplay()

            if isLiked {
                likesCount += 1
                likeCountLabel!.text = String(likesCount)
                likeImageName = "heart.fill"
                likeImageView.image = UIImage(systemName: likeImageName)
            } else {
                likesCount -= 1
                likeCountLabel!.text = String(likesCount)
                likeImageName = "heart"
                likeImageView.image = UIImage(systemName: likeImageName)
            }
        }
}
