//
//  ViewCategoryTableViewController.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 7/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreLocation

class ViewCategoryTableViewController: UITableViewController, CLLocationManagerDelegate {
    @IBOutlet var viewCategoryTableView: UITableView!
    var viewCategoryTitle: String = ""
    var postList: [Post] = []   // Contain post of chosen category
    var userList: [User] = []
    
    // List to contain posts not made by current user
    var modifiedList: [Post] = []
    
    // List to contain all location calculation
    var locationDist: [Double] = []
    
    var username: String = ""
    var curruid: String = ""

    var lm : CLLocationManager?
    var userCoord: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title of viewController to be the selected category name
        self.title = viewCategoryTitle
        if viewCategoryTitle == "Nearby Location" {
            lm = CLLocationManager()
            lm?.delegate = self
            lm?.desiredAccuracy = kCLLocationAccuracyBest   // Best accuracy
            lm?.requestWhenInUseAuthorization() // Location permission
            lm?.distanceFilter = 0
            
            // Background to foreground check if permission changed
            NotificationCenter.default.addObserver(self, selector: #selector(changeSettingsPermission(notfication:)), name: NSNotification.Name(rawValue: "changeLocAuth"), object: nil)
            
            // Check if location authorized
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways, .authorizedWhenInUse:
                    // Set user coordinate
                    userCoord = CLLocation(latitude: (lm?.location?.coordinate.latitude)!, longitude: (lm?.location?.coordinate.longitude)!)
                    loadPosts()
                case .notDetermined:
                    lm?.requestWhenInUseAuthorization() // Location permission
                case .restricted, .denied:
                    // Create alertcontroller to tell user to enable permission
                    let alertController = UIAlertController(title: "User location not found!", message: "Please go to Settings and enable permissions", preferredStyle: .alert)
                    
                    // Bring user to settings for location
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                         }
                    }
                    
                    // If cancel go to prev controller
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
                        (action:UIAlertAction!) in
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    // Add actions to alertcontroller
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                    self.present(alertController, animated: true, completion: nil)
                default:
                    break
                }
            }
        }
        else {
            loadPostsByCategory(viewCategoryTitle)
        }
    }
    
    // Check after changing permissions from settings
    @objc func changeSettingsPermission(notfication: NSNotification) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            // Set user coordinate
            userCoord = CLLocation(latitude: (lm?.location?.coordinate.latitude)!, longitude: (lm?.location?.coordinate.longitude)!)
            loadPosts()
        case .denied, .restricted:
            permissionNotAllowed()
        case .notDetermined:
            lm?.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    // This function is triggered when the view is about to appear.
    override func viewWillAppear(_ animated: Bool) {
        // Check username
        if Auth.auth().currentUser != nil {
            // Get the current user
            let user = Auth.auth().currentUser
            if let user = user {
                // Get current user id
                let uidd: String = user.uid
                DataManager.loadUser() {
                    userListFromFirestore in
                    self.userList = userListFromFirestore
                    for i in self.userList {
                        // Get current user's user name and save user id
                        if (i.uid == uidd) {
                            self.username = i.username
                            self.curruid = i.uid
                        }
                    }
                }
            }
        }
    }
    
    // Called when the view is visible
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Deselect selected row
        let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow {
            tableView.deselectRow(at: selectedRowNotNill, animated: true)
        }
    }
    
    // Check if change status but still deny or not determined
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            permissionNotAllowed()
        }
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization() // Location permission
        }
    }
    
    // Function of didFailwithError to check if still denying
    func permissionNotAllowed() {
        // Create alertcontroller to tell user to enable permission
        let alertController = UIAlertController(title: "User location not found!", message: "Please go to Settings and enable permissions", preferredStyle: .alert)
        
        // Bring user to settings for location
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
             }
        }
        
        // If cancel go to prev controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
            (action:UIAlertAction!) in
            
            self.navigationController?.popViewController(animated: true)
        }
        
        // Add actions to alertcontroller
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Function to calculate the distance from user location.
    func calculateDistance(_ userLoc: CLLocation,_ dest: CLLocation) -> Double {
        return dest.distance(from: userLoc)
    }
    
    // Function that loads posts from Firestore
    func loadPosts() {
        DataManager.loadPosts()
        {
            postListFromFirestore in

            // Assign list to list from Firestore
            self.postList = postListFromFirestore

            // Check if list is empty
            if self.postList.count == 0 {
                let labelDisplay = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)) // Create label
                labelDisplay.text = "No post has been created" // Set label text
                labelDisplay.textAlignment = .center
                labelDisplay.sizeToFit()
                
                self.tableView.backgroundView = labelDisplay
                self.tableView.separatorStyle = .none   // Remove the lines from tableview
            }
            else {
                self.tableView.backgroundView = nil  // Remove label if present
                self.tableView.separatorStyle = .singleLine // Set lines to tableview

                // Append post to modifiedList
                for index in 0..<self.postList.count {
                    if self.postList[index].uid != self.curruid {
                        self.modifiedList.append(self.postList[index])
                    }
                }
                
                // Calculate distance between user location and dest
                for post in self.modifiedList {
                    let coords = CLLocation(latitude: post.latitude, longitude: post.longitude)
                    let dist = self.calculateDistance(self.userCoord!, coords)
                    self.locationDist.append(dist)
                }
                                
                // Combine array to sort by ascending order together
                let combined = zip(self.locationDist, self.modifiedList).sorted(by: {$0.0 < $1.0})

                // Extract individual array after sorting
                self.locationDist = combined.map {$0.0}
                self.modifiedList = combined.map {$0.1}
            }
            
            // Reload content in tableView
            self.tableView.reloadData()
        }
    }
    
    // Function that loads data based on category from Firestore and refreshes tableView
    func loadPostsByCategory(_ category:String) {
        DataManager.loadPostsByCategory(category)
        {
            postListFromFirestore in

            // Assign list to list from Firestore
            self.postList = postListFromFirestore

            // Check if list is empty
            if self.postList.count == 0 {
                let labelDisplay = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)) // Create label
                labelDisplay.text = "No posts under this category" // Set label text
                labelDisplay.textAlignment = .center
                labelDisplay.sizeToFit()
                
                self.tableView.backgroundView = labelDisplay
                self.tableView.separatorStyle = .none   // Remove the lines from tableview
            }
            else {
                self.tableView.backgroundView = nil  // Remove label if present
                self.tableView.separatorStyle = .singleLine // Set lines to tableview
            }
            
            // Reload content in tableView
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewCategoryTitle == "Nearby Location" {
            return modifiedList.count
        }
        else {
            return postList.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ViewCategoryCell = tableView.dequeueReusableCell (withIdentifier: "ViewCategoryCell", for: indexPath) as! ViewCategoryCell

        if viewCategoryTitle == "Nearby Location" {
            // Use the reused cell/newly created cell and update it
            let p = modifiedList[indexPath.row]
            cell.titleLabel.text = p.title
            cell.titleLabel.sizeToFit()
            cell.postImageView.image = p.thumbnail.getImage()
            cell.priceLabel.text = "$\(p.price)"
            cell.descLabel.text = p.desc
            
            DataManager.loadUser() {
                userListFromFirestore in
                self.userList = userListFromFirestore
                for i in self.userList {
                    if (i.uid == p.uid) {
                        cell.usernameLabel.text = i.username
                    }
                }
            }
        }
        else {
            // Use the reused cell/newly created cell and update it
            let p = postList[indexPath.row]
            cell.titleLabel.text = p.title
            cell.titleLabel.sizeToFit()
            cell.postImageView.image = p.thumbnail.getImage()
            cell.priceLabel.text = "$\(p.price)"
            cell.descLabel.text = p.desc
            
            DataManager.loadUser() {
                userListFromFirestore in
                self.userList = userListFromFirestore
                for i in self.userList {
                    if (i.uid == p.uid) {
                        cell.usernameLabel.text = i.username
                    }
                }
            }
        }
        cell.usernameLabel.sizeToFit()
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowPostDetails")
        {
            // Get the new view controller using segue.destination.
            let viewPostViewController = segue.destination as! ViewPostViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            if(myIndexPath != nil) {
                if viewCategoryTitle == "Nearby Location" {
                    // Set the post object to selected post
                    let post = modifiedList[myIndexPath!.row]
                    viewPostViewController.currPostId = post.id
                    viewPostViewController.post = post
                }
                else {
                    // Set the post object to selected post
                    let post = postList[myIndexPath!.row]
                    viewPostViewController.currPostId = post.id
                    viewPostViewController.post = post
                }
            }
        }
    }
}
