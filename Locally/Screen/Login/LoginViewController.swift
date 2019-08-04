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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.isLoading(true)
    }
    
    private func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "NetworkUnavailable", sender: self)
        }
    }
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                //User created
                print("User created")
                //User signed in
                self.signInUser(email: email, password: password)
            } else {
                print(error?.localizedDescription)
                let alert = UIAlertController(title: error!.localizedDescription, message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    func signInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail:email, password: password) { (result, error) in
            if error == nil {
                print("User signed in")
                self.performSegue(withIdentifier: "loginToLocation", sender: self)
            } else if (error?._code == AuthErrorCode.userNotFound.rawValue){
                self.createUser(email: email, password: password)
            } else {
                print(error)
                print(error?.localizedDescription)
                let alert = UIAlertController(title: error!.localizedDescription, message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                DispatchQueue.main.async(execute: {
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        signInUser(email: emailTextField!.text!, password: passwordTextField!.text!)
    }
}
