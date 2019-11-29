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
import SwiftMessages

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.isHidden = false
        }
        setupTextFieldPlaceholders()
        setupElements()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.showActivityIndicator(onView: view)
    }

    func setupTextFieldPlaceholders() {
        let iVar = class_getInstanceVariable(UITextField.self, "_placeholderLabel")!
        let placeholderLabelName = object_getIvar(firstNameTextField, iVar) as! UILabel
        placeholderLabelName.textColor = .systemGray2
        let placeholderLabelLastName = object_getIvar(lastNameTextField, iVar) as! UILabel
        placeholderLabelLastName.textColor = .systemGray2
        let placeholderLabel = object_getIvar(emailTextField, iVar) as! UILabel
        placeholderLabel.textColor = .systemGray2
        let placeholderLabelPassword = object_getIvar(passwordTextField, iVar) as! UILabel
        placeholderLabelPassword.textColor = .systemGray2
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
                    self.showStatusLine("Error creating user")
                } else {
                    //User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()

                    db.collection("users").addDocument(data: ["firstname": firstName, "lastname": lastName, "uid": result!.user.uid]) {(error) in

                        if error != nil {
                            //Show error message
                            self.showError("Error saving user data")
                            self.showStatusLine("Error saving user data")
                        }
                    }
                    //Transition to the home screen
                    self.transitionToLoginView()
                }
            }
            self.showActivityIndicator(onView: view)
            self.showStatusLine("You have signed up successfully!")
        }
    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

    func transitionToLoginView() {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }

    func showStatusLine(_ message: String) {
        let view: MessageView = try! SwiftMessages.viewFromNib(named: "StatusLine")
        SwiftMessages.show(view: view)
        view.bodyLabel?.textColor = .green
        view.bodyLabel?.text = message
        
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                return false
            }
        }
        catch {
            self.makeAlert(titleInput: "Character Warning!", messageInput: "An error ocurred when filling in the name and surname fields")
        }
        return true
    }
}
