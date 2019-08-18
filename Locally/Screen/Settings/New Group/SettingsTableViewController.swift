//
//  SideMenuTableViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 3.08.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit
import Firebase

protocol SettingsTableViewControllerDelegate: class {
    func signoutTapped()
}

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    weak var delegate: SettingsTableViewControllerDelegate?

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if (indexPath.row == 0) {
            // tell the delegate (view controller) to perform signoutTapped() function
            if let delegate = delegate {
                delegate.signoutTapped()
            }
        }
        print("selected index path in settings: \(indexPath.row)")
    }
}
