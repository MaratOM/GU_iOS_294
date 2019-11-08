//
//  LikeControl.swift
//  VK
//
//  Created by Marat Mikaelyan on 08/11/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class LikeControl: UIControl {
    @IBInspectable var filled: Bool = true
    @IBInspectable var strokeWidth: CGFloat = 2.0

    @IBInspectable var strokeColor: UIColor?
    @IBInspectable var fillColor: UIColor?


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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#function)

        setGestureRecognizer()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(#function)
        
        setGestureRecognizer()
        backgroundColor = .clear
    }
    
    func setGestureRecognizer() {
//        let gr: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
//        gr.numberOfTapsRequired = 1
//        addGestureRecognizer(gr)
        
        print(#function)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    @objc private func tapped(_ tapGesture: UITapGestureRecognizer) {
        print(#function)
    }
    
}
