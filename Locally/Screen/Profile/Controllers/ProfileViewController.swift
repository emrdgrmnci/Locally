//
//  ProfileViewController.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 16.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import CoreData
import SDWebImage

class ProfileViewController: UIViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var horizontalLine: UIView!
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var addPhoto: UIButton!
    @IBOutlet weak var savePhoto: UIButton!
    @IBOutlet weak var dinelineTableView: UITableView!
    var movingView = UIView()
    var imagePicker: UIImagePickerController!
    var img = #imageLiteral(resourceName: "home")
    var isSideMenuOpen = false
    private let locationManager = CLLocationManager()
    private let locationService = LocationService()
    let cellId = "cellId"
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var imageArray = [NSData]()
    var idArray = [UUID]()
    var userEmail = [String]()
    var likes = [Int]()
    var restaurantImage = [String]()
    var documentIDs = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //        let screenWidth = UIScreen.main.bounds.width
        movingView = UIView(frame: CGRect(x: 10, y: -20, width: 50, height: 5))
        movingView.backgroundColor = .red
        horizontalLine.addSubview(movingView)

        dinelineTableView.delegate = self
        dinelineTableView.dataSource = self

        getUserDetails()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleSideMenu),
                                               name: NSNotification.Name("ToggleSideMenu"), object: nil)
        getData()
        getDataFromFirestore()
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
    func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocalData")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                if let imageData = result.value(forKey: "image") as? NSData {
                    if let image = UIImage(data:imageData as Data) {
                        collectionImageView.image = image
                    }
                }
            }
        } catch {
            print("error")
        }
    }
    @IBAction func logoutBarButtonTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "logoutSegue", sender: nil)
        } catch {
            print("Log out error!")
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
                output += "\(town)"
            }
            self.userLocationLabel.text = "\(output)"
            print(output)
        }
    }
    // MARK: - Get Database
    func getDataFromFirestore() {
        let firestoreDatabase = Firestore.firestore()
        // TODO: - If you have get error about time use below code block!
        /*let settings = firestoreDatabase.settings
         settings.areTimestampsInSnapshotsEnabled = true
         firestoreDatabase.settings = settings*/

        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {

                    self.restaurantImage.removeAll(keepingCapacity: false)
                    self.userEmail.removeAll(keepingCapacity: false)
                    self.likes.removeAll(keepingCapacity: false)
                    self.documentIDs.removeAll(keepingCapacity: false)

                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIDs.append(documentID)

                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmail.append(postedBy)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likes.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.restaurantImage.append(imageUrl)
                        }
                    }
                    self.dinelineTableView.reloadData()
                }
            }
        }
    }
    @IBAction func dineline(_ sender: UIButton) {
        sender.shake()
        addPhoto.isHidden = false
        savePhoto.isHidden = false
        let newx = sender.frame.origin.x + 5
        UIView.animate(withDuration: 0.5) {
            self.movingView.frame.origin.x = newx
        }
        //        let dineline = UIImage(named: "dineline")!
        //        self.collectionImageView.image = dineline
    }
    @IBAction func reviews(_ sender: UIButton) {
        sender.shake()
        addPhoto.isHidden = true
        savePhoto.isHidden = true
        let newx = sender.frame.origin.x + 5
        UIView.animate(withDuration: 0.5) {
            self.movingView.frame.origin.x = newx
        }
        //        let review = UIImage(named: "review")!
        //        self.collectionImageView.image = review
    }
    @IBAction func photos(_ sender: UIButton) {
        sender.shake()
        addPhoto.isHidden = false
        savePhoto.isHidden = false
        let newx = sender.frame.origin.x + 5
        UIView.animate(withDuration: 0.5) {
            self.movingView.frame.origin.x = newx
        }
        //        let photos = UIImage(named: "photos")!
        //        self.collectionImageView.image = photos
    }
    @IBAction func beenThere(_ sender: UIButton) {
        sender.shake()
        addPhoto.isHidden = true
        savePhoto.isHidden = true
        let newx = sender.frame.origin.x + 5
        UIView.animate(withDuration: 0.5) {
            self.movingView.frame.origin.x = newx
        }
        if addPhoto.isHidden == true {
            let beenthere = UIImage(named: "beenthere")!
            self.collectionImageView.image = beenthere
        }
    }
}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmail.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dinelineCell", for: indexPath) as! DinelineTableViewCell
        cell.userEmailLabel.text = userEmail[indexPath.row]
        cell.likeLabel.text = String(likes[indexPath.row])
        cell.commentLabel.text = "comment çokzel"
        cell.restaurantImageView.sd_setImage(with: URL(string: self.restaurantImage[indexPath.row]))
        cell.documentIdLabel.text = documentIDs[indexPath.row]
        return cell
    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        do {
    //            try Auth.auth().signOut()
    //            performSegue(withIdentifier: "logoutSegue", sender: nil)
    //        } catch {
    //            print("Log out error!")
    //        }
    //    }
}
extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        collectionImageView.image = info[.originalImage] as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func addPhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func savePhoto(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()

        let mediaFolder = storageReference.child("media")

        if let data = collectionImageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL(completion: { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString

                            //DATABASE
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference: DocumentReference? = nil
                            let firestorePost = ["imageUrl": imageUrl!,
                                                 "postedBy": Auth.auth().currentUser!.email!,
                                                 "date": FieldValue.serverTimestamp(),
                                                 "likes": 0] as [String : Any]
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    self.collectionImageView.image = UIImage(named: "placeholder")
//                                    self.tabBarController?.selectedIndex = 1
                                }
                            })
                        }
                    })
                }
            }

        }
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        let context = appDelegate.persistentContainer.viewContext
        //        let data = (collectionImageView?.image)!.pngData() //.jpegData(compressionQuality: 0.5)
        //        let newUser = NSEntityDescription.insertNewObject(forEntityName: "LocalData", into: context)
        //        newUser.setValue(data, forKey: "image")
        //        do {
        //            try context.save()
        //            print("success")
        //        } catch {
        //            print("error")
        //        }
    }
}
extension UITableView {
    //Hides the empty cells at the bottom of the table view.
    func hideEmptyCellsFooter() {
        tableFooterView = UIView()
    }
}
