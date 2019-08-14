//
//  SideMenuTableViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 3.08.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit
import Firebase

class SideMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SideMenuTableViewController.swipedLeft))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }

    @objc func swipedLeft() {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            do {
                try Auth.auth().signOut()
                performSegue(withIdentifier: "logoutSegue", sender: nil)
            } catch {
                print("Log out error!")
            }
        default:
            return
        }
        print(indexPath.row)
    }

}
