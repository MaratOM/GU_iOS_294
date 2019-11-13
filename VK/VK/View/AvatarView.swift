//
//  AvatarView.swift
//  VK
//
//  Created by Marat Mikaelyan on 07/11/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class AvatarView: UIView {
    @IBOutlet var friendImageView: UIImageView!
    @IBOutlet var shadowView: UIView!

    @IBInspectable var shadowColor = UIColor.black

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 7
        shadowView.layer.shadowOpacity = 0.8
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        friendImageView.layer.cornerRadius = bounds.height/2
        shadowView.layer.cornerRadius = bounds.height/2

    }
}
