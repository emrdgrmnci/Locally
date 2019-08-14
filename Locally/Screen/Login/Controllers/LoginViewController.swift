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
        self.isLoading(true)
    }
    private func showOfflinePage() {
        DispatchQueue.main.async {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let offlineVC: UIViewController = (mainStoryboard.instantiateViewController(withIdentifier: "OfflineViewController") as? OfflineViewController)!
            self.present(offlineVC, animated: true, completion: nil)
        }
    }
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if error == nil {
                //User created
                print("User created")
                //User signed in
                self.signInUser(email: email, password: password)
            } else {
                print(error?.localizedDescription ?? "error")
                let alert = UIAlertController(title: error!.localizedDescription, message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }
    func signInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if error == nil {
                print("User signed in")
                self.performSegue(withIdentifier: "loginToLocation", sender: self)
            } else if error?._code == AuthErrorCode.userNotFound.rawValue {
                self.createUser(email: email, password: password)
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
