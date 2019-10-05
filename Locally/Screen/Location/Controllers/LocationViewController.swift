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
        locationView.didTapAllow = {
            self.delegate?.didTapAllow()
            DispatchQueue.main.async {
                self.showActivityIndicator(onView: self.view)
            }
        }
        locationView.didTapDeny = {
            self.delegate?.didTapDeny()
            let alert = UIAlertController(title: "Settings", message: "Please go to settings and turn on the location permissions!", preferredStyle: UIAlertController.Style.alert)
            self.present(alert, animated: true, completion: nil)
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(cancelButton)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style {
                case .default: UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                self.removeActivityIndicator()
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
                self.removeActivityIndicator()
                let tab = self.storyboard!
                    .instantiateViewController(withIdentifier: "TabbarController") as? UITabBarController
                tab!.modalPresentationStyle = .fullScreen
                self.present(tab!, animated: true, completion: nil)
                //RestaurantTableViewController
            }
        }
    }
    func alertLocationAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        let alert = UIAlertController(
            title: "Need Location Access",
            message: "Location access is required for including the location of the hazard.",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Location Access",
                                      style: .cancel,
                                      handler: {(alert) -> Void in
                                        UIApplication.shared.open(settingsAppURL,
                                                                  options: [:],
                                                                  completionHandler: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                hasPermission = false
                DispatchQueue.main.async {
                    self.removeActivityIndicator()
                }
            case .restricted, .denied:
                self.alertLocationAccessNeeded()
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
//                 DispatchQueue.main.async {
//                           self.showActivityIndicator()
//                }
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
