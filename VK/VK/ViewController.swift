//
//  ViewController.swift
//  VK
//
//  Created by User on 19/10/2019.
//  Copyright © 2019 maratom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var LoginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
        print("Login: \(loginTextField.text!)")
        print("Password: \(passwordTextField.text!)")
    }
    
}

