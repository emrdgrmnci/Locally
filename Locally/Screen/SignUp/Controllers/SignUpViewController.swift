//
//  SignUpViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 21.09.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }

    func setupElements() {
        //Hide the error label
        errorLabel.alpha = 0

        //Customization for textfields
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }

    //Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message.
    func validateFields() -> String? {

        //Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }

        //Check if the password secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }

        return nil
    }

    @IBAction func signUpTapped(_ sender: Any) {
        //Validate the fields
        let error = validateFields()

        if error != nil {

            //there's smth wrong with the fields, show error message
            showError(error!)
        } else {
            //Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in

                //Check for errors
                if error != nil {

                    //There was an error creting the user
                    self.showError("Error creating user")
                } else {
                    //User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()

                    db.collection("users").addDocument(data: ["firstname": firstName, "lastname": lastName, "uid": result!.user.uid]) {(error) in

                        if error != nil {
                            //Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    //Transition to the home screen
                    self.trasitionToHome()
                }
            }

        }
    }

    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

    func trasitionToHome() {
        let locationViewController = storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController

        view.window?.rootViewController = locationViewController
        view.window?.makeKeyAndVisible()
    }
}