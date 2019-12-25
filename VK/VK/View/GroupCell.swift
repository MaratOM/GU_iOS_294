//
//  GroupCell.swift
//  VK
//
//  Created by User on 26/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit
import Kingfisher

class GroupCell: UITableViewCell {
    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet var groupTitleLabel: UILabel!
    
    public func configure(with group: Group) {
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        self.groupTitleLabel?.textColor = UIColor.white
        
        groupTitleLabel.text = group.title
        groupImageView.kf.setImage(with: URL(string: group.imageURL))
    }
}
