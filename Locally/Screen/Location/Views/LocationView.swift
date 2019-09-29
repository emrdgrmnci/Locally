//
//  LocationView.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 6.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit

 class LocationView: BaseView {

    @IBOutlet weak var allowButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
    @IBOutlet weak var locationImage: UIImageView!

    let locationService = LocationService()
    let nav = UINavigationController()
    let restaurant = RestaurantTableViewController()

    var didTapAllow: (() -> Void)?
    var didTapDeny: (() -> Void)?

    @IBAction func allowAction(_ sender: UIButton) {
        didTapAllow?()
        locationService.requestLocationAuthorization()
    }

    @IBAction func denyAction(_ sender: UIButton) {
        didTapDeny?()

    }
}
