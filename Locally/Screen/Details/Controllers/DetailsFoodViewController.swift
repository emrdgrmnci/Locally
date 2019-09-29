//
//  DetailsFoodViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 6.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit
import AlamofireImage
import MapKit
import CoreLocation

class DetailsFoodViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var detailsFoodView: DetailsFoodView?
    @IBOutlet weak var isFavorite: UIButton!
    let locationManager = CLLocationManager()
    var imagePicker: UIImagePickerController!
    var isFavorited = true
    var viewModel: DetailsViewModel? {
        didSet {
            updateView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsFoodView?.collectionView!.register(
            DetailsCollectionViewCell.self,
            forCellWithReuseIdentifier: "ImageCell")
        detailsFoodView?.collectionView?.dataSource = self
        detailsFoodView?.collectionView?.delegate = self
        detailsFoodView?.mapView?.delegate = self
        detailsFoodView?.mapView?.showsUserLocation = true
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        // initialize the likes button to reflect the current state
        self.isFavorite.isSelected = self.likes
        // set the titles for the likes button per state
        self.isFavorite.setTitle("YES", for: .normal)
        self.isFavorite.setTitleColor(UIColor(red: 0.2118, green: 0.749, blue: 0, alpha: 1.0), for: .normal)
        self.isFavorite.setTitle("NO", for: .selected)
        self.isFavorite.setTitleColor(.red, for: .selected)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    private func showOfflinePage() {
        DispatchQueue.main.async {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let offlineVC: UIViewController = (mainStoryboard.instantiateViewController(withIdentifier: "OfflineViewController") as? OfflineViewController)!
            self.present(offlineVC, animated: true, completion: nil)
        }
    }

    func dialNumber(number : String) {

        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }

    @IBAction func phoneCallButton(_ sender: UIButton) {
        if let viewModel = viewModel {
            dialNumber(number: viewModel.phoneNumber)
        }
    }

    /*guard let phoneNumber = sender.locationLabel?.text, let url = URL(string: "telprompt://\(phoneNumber)") else {
     return
     }
     UIApplication.shared.open(url)*/

    @IBAction func getDirectionsButton(_ sender: Any) {
        if let viewModel = viewModel {
        openMapsAppWithDirections(to: CLLocationCoordinate2D(
            latitude: (viewModel.coordinate.latitude),
            longitude: ((viewModel.coordinate.longitude))),
                                  destinationName: "Destination")
            if viewModel.phoneNumber == nil || viewModel.coordinate == nil {
                self.phoneCallAndMapAlert(titleInput: "Location/Phone Number", messageInput: "This place has not location or phone number")
            }
        }
    }
    private func mapView(mapView: MKMapView,
                         annotationView: MKAnnotationView,
                         calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.leftCalloutAccessoryView {
            if let annotation = annotationView.annotation {
                // Unwrap the double-optional annotation.title property or
                // name the destination "Unknown" if the annotation has no title
                let destinationName = (annotation.title ?? nil) ?? "\(String(describing: viewModel?.name))"
                openMapsAppWithDirections(to: annotation.coordinate, destinationName: destinationName)
            }
        }
    }
    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String) {
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = viewModel?.name // Provide the name of the destination in the To: field
        mapItem.openInMaps(launchOptions: options)
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    func updateView() {
        if let viewModel = viewModel {
            detailsFoodView?.priceLabel?.text = viewModel.price
            detailsFoodView?.hoursLabel?.text = viewModel.isOpen
            detailsFoodView?.locationLabel?.text = viewModel.phoneNumber
            detailsFoodView?.ratingsLabel?.text = viewModel.rating
            detailsFoodView?.reviewCountLabel?.text = viewModel.reviewCount
            detailsFoodView?.collectionView?.reloadData()
            centerMap(for: viewModel.coordinate)
            print("Your destination is: \(viewModel.coordinate)")
            title = viewModel.name
            print("title: \(String(describing: title))")
        }
    }
    func centerMap(for coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        detailsFoodView?.mapView?.addAnnotation(annotation)
        detailsFoodView?.mapView?.setRegion(region, animated: true)
    }
    var likes: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "likes")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "likes")
        }
    }
    @IBAction func favoriteTapped(_ sender: AnyObject) {
        // toggle the likes state
        self.likes = !self.isFavorite.isSelected
        // set the likes button accordingly
        self.isFavorite.isSelected = self.likes
    }
}

extension DetailsFoodViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func addPhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
}
extension DetailsFoodViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.imageUrls.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell",
                                                      for: indexPath) as! DetailsCollectionViewCell
        if let url = viewModel?.imageUrls[indexPath.item] {
            cell.imageView.af_setImage(withURL: url)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        detailsFoodView?.pageControl?.currentPage = indexPath.item
    }
}
