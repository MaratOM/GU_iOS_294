//
//  LikeButton.swift
//  VK
//
//  Created by Marat Mikaelyan on 08/11/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

@IBDesignable
class LikeButton: UIControl {
    @IBInspectable var filled: Bool = true
    @IBInspectable var strokeWidth: CGFloat = 2.0

    @IBInspectable var strokeColor: UIColor?
    @IBInspectable var fillColor: UIColor?
    
    @IBAction func likeButton(_ sender: Any) {
        print(#function)
    }
    


    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
//        guard let context = UIGraphicsGetCurrentContext() else { return }

        let bezierPath = UIBezierPath(heartIn: self.bounds)

        if self.strokeColor != nil {
            self.strokeColor!.setStroke()
        } else {
            self.tintColor.setStroke()
        }

        bezierPath.lineWidth = self.strokeWidth
        bezierPath.stroke()

        if self.filled {
            self.tintColor.setFill()
            bezierPath.fill()
        }
        
        
        
    }
    
}
