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
    func didTapDeny()
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
        locationView.didTapDeny = {
            self.delegate?.didTapDeny()
            let alert = UIAlertController(title: "Settings", message: "Allow location from settings", preferredStyle: UIAlertController.Style.alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "", style: .default, handler: { action in
                switch action.style {
                case .default: UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                self.isLoading(false)
                case .cancel: print("cancel")
                case .destructive: print("destructive")
                }
            }))
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
                tab!.modalPresentationStyle = .fullScreen
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
                DispatchQueue.main.async {
                    self.isLoading(false)
                }
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
