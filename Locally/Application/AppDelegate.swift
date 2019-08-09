//
//  AppDelegate.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 6.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit
import Moya
import CoreLocation
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow()
    let network = NetworkManager.sharedInstance
    let locationService = LocationService()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let restaurantStoryboard = UIStoryboard(name: "RestaurantTableView", bundle: nil)
    let service = MoyaProvider<YelpService.BusinessProvider>()
    let jsonDecoder = JSONDecoder()
    var navigationController: UINavigationController?
    var tabbarController: UITabBarController?
    let locationManager = CLLocationManager()
    var data: [RestaurantListViewModel]?
    var restaurant = RestaurantTableViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // MARK: - IQKeyboardMangaer
        IQKeyboardManager.shared.enable = true

        // MARK: - Firebase
        FirebaseApp.configure()

        NetworkManager.isUnreachable { _ in
            showOfflinePage()
        }

        func showOfflinePage() {
            DispatchQueue.main.async {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController: UIViewController = (mainStoryboard.instantiateViewController(withIdentifier: "OfflineViewController") as? OfflineViewController)!
                self.window.rootViewController = initialViewController
            }
        }

        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        locationService.didChangeStatus = { [weak self] success in
            if success {
                self?.locationService.getLocation()
            }
        }

        locationService.newLocation = { [weak self ] result in
            switch result {
            case .success(let location):
                self?.loadBusinesses(with: location.coordinate)
            case .failure(let error):
                assertionFailure("Error getting the users location \(error)")
                let alert = UIAlertController(title: error.localizedDescription, message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            }
        }

        switch locationService.status {
        case .notDetermined:
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            window.rootViewController = loginViewController
        case .denied, .restricted:
            let locationViewController = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController
            locationViewController?.delegate = self
            window.rootViewController = locationViewController
        default :
            let nav = restaurantStoryboard
                .instantiateViewController(withIdentifier: "RestaurantNavigationController") as? UINavigationController
            self.navigationController = nav
            window.rootViewController = nav
            locationService.getLocation()
            (nav?.topViewController as? RestaurantTableViewController)?.delegate = self
        }
        window.makeKeyAndVisible()

        return true
    }

    private func loadDetails(for viewController: UIViewController, with id: String) {
        service.request(.details(id: id)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let strongSelf = self else { return }
                if let details = try? strongSelf.jsonDecoder.decode(Details.self, from: response.data) {
                    let detailsViewModel = DetailsViewModel(details: details)
                    (viewController as? DetailsFoodViewController)?.viewModel = detailsViewModel
                }
            case .failure(let error):
                print("Failed to get details: \(error)")
            }
        }
    }

    private func loadBusinesses(with coordinate: CLLocationCoordinate2D) {
        service.request(.search(lat: coordinate.latitude, long: coordinate.longitude)) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                let root = try? strongSelf.jsonDecoder.decode(Root.self, from: response.data)
                let viewModels = root?.businesses
                    .compactMap(RestaurantListViewModel.init)
                    .sorted(by: { $0.distance < $1.distance })
                    self?.data = viewModels
                    self?.restaurant.viewModels = viewModels ?? []
                    let tab = strongSelf.storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
                    self?.window.rootViewController = tab
            case .failure(let error):
                print ("Error: \(error)")
            }
        }
    }
}

extension AppDelegate: ListActions, LocationActions {
    func didTapAllow() {
        locationService.requestLocationAuthorization()
    }

    func didTapCell(_ viewController: UIViewController, viewModel: RestaurantListViewModel) {
        loadDetails(for: viewController, with: viewModel.id)
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    //    var rootViewController: LoginViewController {
    //        return window.rootViewController as! LoginViewController
    //    }
}
