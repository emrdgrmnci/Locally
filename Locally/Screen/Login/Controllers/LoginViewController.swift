//
//  ViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 6.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var chefImage: UIImageView!
    let locationServiceStatus = LocationService()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldPlaceholders()
        setupElements()
        signInButton.layer.cornerRadius = 5
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        let storedEmail = UserDefaults.standard.object(forKey: "email")
        let storedPassword = UserDefaults.standard.object(forKey: "password")

        if let email = storedEmail as? String {
            emailTextField.text = email
        }
        if let password = storedPassword as? String {
            passwordTextField.text = password
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
    }

    private func showOfflinePage() {
        DispatchQueue.main.async {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let offlineVC: UIViewController = (mainStoryboard.instantiateViewController(withIdentifier: "OfflineViewController") as? OfflineViewController)!
            self.present(offlineVC, animated: true, completion: nil)
        }
    }
    func setupTextFieldPlaceholders() {
        let iVar = class_getInstanceVariable(UITextField.self, "_placeholderLabel")!
        let placeholderLabel = object_getIvar(emailTextField, iVar) as! UILabel
        placeholderLabel.textColor = .red
        let placeholderLabelPassword = object_getIvar(passwordTextField, iVar) as! UILabel
        placeholderLabelPassword.textColor = .red
    }
    func setupElements() {
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleHollowButton(signInButton)
    }

    func signInUser(email: String, password: String) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil {
                print("User signed in")
                self.performSegue(withIdentifier: "loginToLocation", sender: self)
            } else {
                print(error ?? "error")
                print(error?.localizedDescription ?? "error")
                let alert = UIAlertController(title: error!.localizedDescription, message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }

    @IBAction func signInButtonTapped(_ sender: Any) {
        // MARK: - UserDefaults
        UserDefaults.standard.set(emailTextField.text, forKey: "email")
        UserDefaults.standard.set(passwordTextField.text, forKey: "password")
        signInUser(email: emailTextField!.text!, password: passwordTextField!.text!)
    }
}
