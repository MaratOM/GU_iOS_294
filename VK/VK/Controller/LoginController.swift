//
//  ViewController.swift
//  VK
//
//  Created by User on 19/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var LoginButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = UIColor.black
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGR)
        
        let testView = TestView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        testView.backgroundColor = .white
        testView.layer.borderWidth = 2
        testView.layer.borderColor = UIColor.red.cgColor
        testView.layer.cornerRadius = 16
        testView.layer.masksToBounds = true
        
        testView.layer.shadowColor = UIColor.black.cgColor
        testView.layer.shadowOpacity = 0.5
        testView.layer.shadowRadius = 8
        testView.layer.shadowOffset = CGSize.zero
        
        testView.backgroundColor = .red
        let maskLayer = CAShapeLayer()
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 40, y: 20))
        starPath.addLine(to: CGPoint(x: 45, y: 40))
        starPath.addLine(to: CGPoint(x: 65, y: 40))
        starPath.addLine(to: CGPoint(x: 50, y: 50))
        starPath.addLine(to: CGPoint(x: 60, y: 70))
        starPath.addLine(to: CGPoint(x: 40, y: 55))
        starPath.addLine(to: CGPoint(x: 20, y: 70))
        starPath.addLine(to: CGPoint(x: 30, y: 50))
        starPath.addLine(to: CGPoint(x: 15, y: 40))
        starPath.addLine(to: CGPoint(x: 35, y: 40))
        starPath.close()
        starPath.stroke()
        maskLayer.path = starPath.cgPath // Тот path, с помощью которого рисовали звезду
        testView.layer.mask = maskLayer
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0 as NSNumber, 1 as NSNumber]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)

        testView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = testView.bounds
        
        let translation = CGAffineTransform(translationX: 10, y: 20)
        let scale = CGAffineTransform(scaleX: 1.5, y: 1.5)
        let rotation = CGAffineTransform(rotationAngle: .pi / 4)
        
        testView.transform = scale.concatenating(rotation).concatenating(translation)
        
        let translation3D = CATransform3DMakeTranslation(10, 20, 100)
        let rotation3D = CATransform3DMakeRotation(.pi / 4, 0, 0, 1)
        let scale3D = CATransform3DMakeScale(0.5, 0.5, 1)

        testView.layer.transform = translation3D
        testView.layer.transform = rotation3D
        testView.layer.transform = scale3D

        
        view.addSubview(testView)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)

        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func login(_ sender: Any) {
        guard let login = loginTextField.text,
            let password = passwordTextField.text,
            login == "",
            password == "" else {
                show(message: "Incorrect login/password!")
                return
        }
        
        performSegue(withIdentifier: "Login Segue", sender: nil)
    }
    
    @objc func willShowKeyboard(_ notification: Notification) {
        guard let info = notification.userInfo as NSDictionary?,
            let keyboardSize = info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else { return }
        let keyboardHeight = keyboardSize.cgRectValue.size.height
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)

    }
    
    @objc func willHideKeyboard(_ notification: Notification) {
        scrollView.contentInset = .zero
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
}

