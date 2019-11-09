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
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGR)
    
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

