//
//  FriendCell.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    @IBOutlet var friendImageView: UIImageView!
    @IBOutlet var friendNameLabel: UILabel!
    
    public func configure(with friend: Friend) {
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        self.friendNameLabel?.textColor = UIColor.white
        
        friendNameLabel.text = friend.name
        friendImageView.kf.setImage(with: URL(string: friend.imageURL))
    }
}
