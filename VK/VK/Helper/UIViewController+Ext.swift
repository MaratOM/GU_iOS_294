//
//  UIViewController+Ext.swift
//  VK
//
//  Created by Marat Mikaelyan on 25/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

extension UIViewController {
    func show(message: String) {
        let alertVC = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    func getBackgroundImage() -> UIImageView {
          let background = UIImage(named: "vk_bg")
          var imageView : UIImageView!
        
          imageView = UIImageView(frame: view.bounds)
          imageView.contentMode =  UIView.ContentMode.scaleAspectFill
          imageView.clipsToBounds = true
          imageView.image = background
          imageView.center = view.center
        
          return imageView
      }
}
