//
//  RatingViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 28.08.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
    }
    @IBAction func oneStarTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func twoStarTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func threeStarTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func fourStarTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func fiveStarTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
