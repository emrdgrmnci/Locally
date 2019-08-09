//
//  RestaurantTableViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 6.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit
import CoreLocation

protocol ListActions: class {
    func didTapCell(_ viewController: UIViewController, viewModel: RestaurantListViewModel)
}

class RestaurantTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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

        print("did load")

        userCurrentLocation()
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }

        print(">>>>>>>>>\(String(describing: appDelegate!.data))")
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("did appear")
        self.isLoading(false)
        tableView.reloadData()
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func showOfflinePage() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "NetworkUnavailable", sender: self)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows ----------------------- \(String(describing: viewModels.count))")
        print(viewModels)
        return appDelegate!.data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantTableViewCell
        let vm = appDelegate!.data?[indexPath.row]
        cell.configure(with: vm!)
        print("vm \(String(describing: vm))")
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

}
