//
//  OfflineViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 10.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit

class OfflineViewController: UIViewController {
    let network = NetworkManager.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        // If the network is reachable show the main controller
        network.reachability.whenReachable = { _ in
            self.showMainController()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    private func showMainController() -> Void {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "MainController", sender: self)
        }
    }
}
