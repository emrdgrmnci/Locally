//
//  UIAlertExtension.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 14.08.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit

extension UIViewController {
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    func sureAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        let logoutButton = UIAlertAction(title: "Log out", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
            //            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let splashVC: UIViewController = (mainStoryboard.instantiateViewController(withIdentifier: "SplashViewController") as? SplashViewController)!
            splashVC.modalPresentationStyle = .fullScreen
            self.present(splashVC, animated: true, completion: nil)
        })
        alert.addAction(cancelButton)
        alert.addAction(logoutButton)
        self.present(alert, animated: true, completion: nil)
    }
    func phoneCallAndMapAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let cancelButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
}
