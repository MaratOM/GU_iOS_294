//
//  LikeControl.swift
//  VK
//
//  Created by Marat Mikaelyan on 08/11/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class LikeControl: UIControl {
    @IBInspectable var isLiked: Bool = false
    @IBInspectable var strokeWidth: CGFloat = 2.0

    @IBInspectable var strokeColor: UIColor?
    @IBInspectable var fillColor: UIColor?
    
    @IBOutlet var likesCountLabel: UILabel!
    
    private var likesCount: Int = 0

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let bezierPath = UIBezierPath(heartIn: self.bounds)

        if self.strokeColor != nil {
            self.strokeColor!.setStroke()
        } else {
            self.tintColor.setStroke()
        }

        bezierPath.lineWidth = self.strokeWidth
        bezierPath.stroke()

        if self.isLiked {
            self.tintColor.setFill()
            bezierPath.fill()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setGestureRecognizer()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setGestureRecognizer()
        backgroundColor = .clear
    }
    
    func setGestureRecognizer() {
        let gr: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        gr.numberOfTapsRequired = 1
        addGestureRecognizer(gr)
    }
    
    @objc private func tapped(_ tapGesture: UITapGestureRecognizer) {
        isLiked.toggle()
        setNeedsDisplay()
        
        if isLiked {
            likesCount += 1
            likesCountLabel!.text = String(likesCount)
        } else {
            likesCount -= 1
            likesCountLabel!.text = String(likesCount)
        }
    }
    
    // MARK: -  Public API
    public func configure(likes count: Int, isLikedByUser: Bool) {
        self.likesCount = count
        self.isLiked = isLikedByUser
        
        likesCountLabel.text = String(likesCount)
    }
    
}
