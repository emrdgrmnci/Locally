//
//  LocationViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 12.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationActions: class {
    func didTapAllow()
}

class LocationViewController: UIViewController {

    @IBOutlet weak var locationView: LocationView!

    let locationService = LocationService()

    weak var delegate: LocationActions?

    override func viewDidLoad() {
        super.viewDidLoad()

//        locationService.requestLocationAuthorization()

        locationView.didTapAllow = {
            self.delegate?.didTapAllow()
             self.isLoading(true)
        }
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if hasLocationPermission() {
            DispatchQueue.main.async {
                self.isLoading(false)
                let tab = self.storyboard!
                    .instantiateViewController(withIdentifier: "TabbarController") as? UITabBarController
                self.present(tab!, animated: true, completion: nil)
                //RestaurantTableViewController

            }
        }
    }

    func hasLocationPermission() -> Bool {
        var hasPermission = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            @unknown default:
                fatalError()
            }
        } else {
            hasPermission = false
        }

        return hasPermission
    }

    private func showOfflinePage() {
        DispatchQueue.main.async {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let offlineVC: UIViewController = (mainStoryboard.instantiateViewController(withIdentifier: "OfflineViewController") as? OfflineViewController)!
            self.present(offlineVC, animated: true, completion: nil)
        }
    }
}
