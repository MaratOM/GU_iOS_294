//
//  BigPhotoController.swift
//  VK
//
//  Created by Marat Mikaelyan on 27/11/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class BigPhotoController: UIViewController {

    @IBOutlet var photoImageView: UIImageView! {
        didSet {
            photoImageView.isUserInteractionEnabled = true
        }
    }

    var photos: [Photo] = []
    var selectedPhotoIndex = 0
//
//    private let additionalImageView = UIImageView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.photoImageView.image = photos[selectedPhotoIndex].image
//
//        view.insertSubview(additionalImageView, belowSubview: photoImageView)
//        additionalImageView.translatesAutoresizingMaskIntoConstraints = false
//        additionalImageView.contentMode = .scaleAspectFit
//        NSLayoutConstraint.activate([
//            additionalImageView.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor),
//            additionalImageView.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
//            additionalImageView.topAnchor.constraint(equalTo: photoImageView.topAnchor),
//            additionalImageView.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor)
//        ])
//
//        let swipeLeftGR = UISwipeGestureRecognizer(target: self, action: #selector(photoSwipedLeft(_:)))
//        swipeLeftGR.direction = .left
//        photoImageView.addGestureRecognizer(swipeLeftGR)
//
//        let swipeRightGR = UISwipeGestureRecognizer(target: self, action: #selector(photoSwipedRight(_:)))
//        swipeRightGR.direction = .right
//        photoImageView.addGestureRecognizer(swipeRightGR)
//    }
//
//    @objc func photoSwipedLeft(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
//        guard selectedPhotoIndex + 1 < photos.count else { return }
//
//        additionalImageView.image = self.photos[self.selectedPhotoIndex + 1].image
//        additionalImageView.transform = CGAffineTransform(translationX: self.additionalImageView.bounds.width * 2, y: 200).concatenating(CGAffineTransform(scaleX: 1.6, y: 1.6))
//
//        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
//            self.photoImageView.transform = CGAffineTransform(translationX: -self.photoImageView.bounds.width * 2, y: -200).concatenating(CGAffineTransform(scaleX: 0.6, y: 0.6))
//            self.additionalImageView.transform = .identity
//        }, completion: { _ in
//            self.selectedPhotoIndex += 1
//            self.photoImageView.image = self.photos[self.selectedPhotoIndex].image
//            self.photoImageView.transform = .identity
//            self.additionalImageView.image = nil
//        })
//    }
//
//    @objc func photoSwipedRight(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
//        guard selectedPhotoIndex > 0 else { return }
//
//        additionalImageView.image = self.photos[self.selectedPhotoIndex - 1].image
//        additionalImageView.transform = CGAffineTransform(translationX: -self.additionalImageView.bounds.width * 2, y: -200).concatenating(CGAffineTransform(scaleX: 1.6, y: 1.6))
//
//        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
//            self.photoImageView.transform = CGAffineTransform(translationX: self.photoImageView.bounds.width * 2, y: 200).concatenating(CGAffineTransform(scaleX: 0.6, y: 0.6))
//            self.additionalImageView.transform = .identity
//        }, completion: { _ in
//            self.selectedPhotoIndex -= 1
//            self.photoImageView.image = self.photos[self.selectedPhotoIndex].image
//            self.photoImageView.transform = .identity
//            self.additionalImageView.image = nil
//        })
//    }
}
