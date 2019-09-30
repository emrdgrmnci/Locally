//
//  RestaurantTableViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 6.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit
import CoreLocation
import SkeletonView

protocol ListActions: class {
    func didTapCell(_ viewController: UIViewController, viewModel: RestaurantListViewModel)
}

class RestaurantTableViewController: UIViewController, SkeletonTableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate {
    @IBOutlet weak var yourLocationLabel: UILabel!
    private let locationManager = CLLocationManager()
    private let locationService = LocationService()
    @IBOutlet weak var tableView: UITableView!
    // i got all data nw from app delegate directly you will find i create variable names data in app delegate and i access it here
    // and please notice there is amount of time till got all data before show so u need show loading or something
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var viewModels = [RestaurantListViewModel]() {

        didSet {
            DispatchQueue.main.async {
                // this no more loading, i notice it load late that is why when reload data in table view not working
            }
        }
    }

    weak var delegate: ListActions?

    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = SkeletonGradient(baseColor: .alizarin)
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        view.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        print("did load")
        userCurrentLocation()
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        //        print(">>>>>>>>>\(String(describing: appDelegate!.data))")
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.isLoading(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("did appear")
        self.isLoading(false)
        tableView.reloadData()
        tableView.dataSource = self
        tableView.delegate = self
        self.view.hideSkeleton()
        self.tabBarController?.tabBar.isHidden = false
    }

    private func showOfflinePage() {
        DispatchQueue.main.async {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let offlineVC: UIViewController = (mainStoryboard.instantiateViewController(withIdentifier: "OfflineViewController") as? OfflineViewController)!
            self.present(offlineVC, animated: true, completion: nil)
        }
    }

    func userCurrentLocation() {
        guard let exposedLocation = self.locationService.exposedLocation else {
            print("*** Error in \(#function): exposedLocation is nil")
            return
        }

        self.locationService.getPlace(for: exposedLocation) { placemark in
            guard let placemark = placemark else { return }
            var output = "Your location: "
            if let town = placemark.subLocality {
                output += "\(town)"
            }
            //            guard let _ = self.yourLocationLabel?.text = "\(output)" else { return }
            if self.yourLocationLabel?.text != nil {
                self.yourLocationLabel?.text = "\(output)"
            }
            print(output)

        }
    }

    // MARK: - Table view data source
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "RestaurantCell"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows ----------------------- \(String(describing: viewModels.count))")
        print(viewModels)
        return appDelegate!.data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantTableViewCell
        //        cell.layer.cornerRadius = 10
        //        cell.layer.masksToBounds = true
        let vm = appDelegate!.data?[indexPath.row]
        cell.configure(with: vm!)
        //        print("vm \(String(describing: vm))")
        return cell
    }

    // MARK: - Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController")
            else {return}
        navigationController?.pushViewController(detailsViewController, animated: true)
        let vm = appDelegate!.data?[indexPath.row]
        appDelegate!.didTapCell(detailsViewController, viewModel: vm!)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self as FiltersViewControllerDelegate
    }
}
