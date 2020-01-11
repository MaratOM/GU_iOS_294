//
//  LikeControl.swift
//  VK
//
//  Created by Marat Mikaelyan on 08/11/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class LikeControlPath: UIControl {
    @IBInspectable var isLiked: Bool = false
    @IBInspectable var strokeWidth: CGFloat = 2.0

    @IBInspectable var strokeColor: UIColor?
    @IBInspectable var fillColor: UIColor?
    
    @IBOutlet var likesCountLabel: UILabel!
    
    private var networkService = NetworkService()
    private var likesCount: Int = 0 {
        didSet {
            likesCountLabel!.text = String(likesCount)
        }
    }
    private var photo: Photo!

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
            networkService.addLike(type: "photo", ownerId: photo.ownerId, id: photo.id)
        } else {
            likesCount -= 1
            networkService.deleteLike(type: "photo", ownerId: photo.ownerId, id: photo.id)
        }
    }
    
    // MARK: -  Public API
    public func configure(photo: Photo) {
        self.likesCount = photo.likesCount
        self.isLiked = photo.isLiked
        self.photo = photo
    }
    
}
