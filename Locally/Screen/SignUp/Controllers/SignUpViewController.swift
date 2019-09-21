//
//  SignUpViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 21.09.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lasstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signUpTapped(_ sender: Any) {
        
    }
}
