//
//  LaunchViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 10.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    let network: NetworkManager = NetworkManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }

        NetworkManager.isReachable { _ in
            self.showMainPage()
        }
    }

    private func showOfflinePage() {
        DispatchQueue.main.async {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let offlineVC: UIViewController = (mainStoryboard.instantiateViewController(withIdentifier: "OfflineViewController") as? OfflineViewController)!
            self.present(offlineVC, animated: true, completion: nil)
        }
    }

    private func showMainPage() {
        DispatchQueue.main.async {
            self.performSegue(
                withIdentifier: "LoginController",
                sender: self
            )
        }
    }
}
