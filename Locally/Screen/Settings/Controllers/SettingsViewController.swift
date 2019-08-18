//
//  SettingsViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 18.08.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    var settingsTableViewController: SettingsTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableViewController = self.children[0] as? SettingsTableViewController
        settingsTableViewController?.delegate = self
    }
}
extension SettingsViewController : SettingsTableViewControllerDelegate {
    func signoutTapped() {
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
}
