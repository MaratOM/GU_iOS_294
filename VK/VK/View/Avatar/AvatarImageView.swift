//
//  AvatarImageView.swift
//  VK
//
//  Created by Marat Mikaelyan on 31/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class AvatarImageView: UIView {

        override func draw(_ rect: CGRect) {
            super.draw(rect)
            
            let imageLayer = CALayer()
            let myImage = UIImage(named: "1")?.cgImage
            imageLayer.frame = self.bounds
            imageLayer.contents = myImage
            
            imageLayer.cornerRadius = imageLayer.frame.size.height / 2;
            imageLayer.masksToBounds = true;
            imageLayer.borderWidth = 0;
            
            self.layer.addSublayer(imageLayer)
    }
            
}
