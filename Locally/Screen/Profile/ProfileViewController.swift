//
//  ProfileViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 16.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var horizontalLine: UIView!
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var addPhoto: UIButton!
    
    var movingView = UIView()
    var imagePicker: UIImagePickerController!
    var img = #imageLiteral(resourceName: "home")
    var isSideMenuOpen = false
    
    private let locationManager = CLLocationManager()
    private let locationService = LocationService()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let screenWidth = UIScreen.main.bounds.width
        
        movingView = UIView(frame: CGRect(x: 10, y: -20, width: 50, height: 5))
        movingView.backgroundColor = .red   //if backgroundView's color is black
        horizontalLine.addSubview(movingView)
        
        getUserDetails()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleSideMenu),
                                               name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         self.isLoading(false)
    }
    
    @objc func toggleSideMenu() {
        if isSideMenuOpen {
            isSideMenuOpen = false
            sideMenuConstraint.constant = -240
        } else {
            isSideMenuOpen = true
            sideMenuConstraint.constant = 0
        }
    }
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    func getUserDetails() {
        if Auth.auth().currentUser != nil {
            guard let email = Auth.auth().currentUser?.email else {return}
            userEmailLabel.text = email
        }
        
        guard let exposedLocation = self.locationService.exposedLocation else {
            print("*** Error in \(#function): exposedLocation is nil")
            return
        }
        
        self.locationService.getPlace(for: exposedLocation) { placemark in
            guard let placemark = placemark else { return }
            var output = ""
            if let town = placemark.subLocality {
                output = output + "\(town)"
            }
            self.userLocationLabel.text = "\(output)"
            print(output)
        }
    }
    @IBAction func dineline(_ sender: UIButton) {
        sender.shake()
        addPhoto.isHidden = false
        
        let newx = sender.frame.origin.x + 5
        UIView.animate(withDuration: 0.5) {
            self.movingView.frame.origin.x = newx
        }
        let dineline = UIImage(named: "dineline")!
        self.collectionImageView.image = dineline
    }
    
    @IBAction func reviews(_ sender: UIButton) {
        sender.shake()
        addPhoto.isHidden = true
        
        let newx = sender.frame.origin.x + 5
        UIView.animate(withDuration: 0.5) {
            self.movingView.frame.origin.x = newx
        }
        let review = UIImage(named: "review")!
        self.collectionImageView.image = review
    }
    @IBAction func photos(_ sender: UIButton) {
        sender.shake()
        addPhoto.isHidden = false
        
        let newx = sender.frame.origin.x + 5
        UIView.animate(withDuration: 0.5) {
            self.movingView.frame.origin.x = newx
        }
        let photos = UIImage(named: "photos")!
        self.collectionImageView.image = photos
    }
    
    @IBAction func beenThere(_ sender: UIButton) {
        sender.shake()
        addPhoto.isHidden = true
        
        let newx = sender.frame.origin.x + 5
        UIView.animate(withDuration: 0.5) {
            self.movingView.frame.origin.x = newx
        }
        let beenthere = UIImage(named: "beenthere")!
        self.collectionImageView.image = beenthere
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "") as! UITableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let logout = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(logout, animated: true, completion: nil)
        }
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBAction func addPhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        collectionImageView.image = info[.originalImage] as? UIImage
    }
}
