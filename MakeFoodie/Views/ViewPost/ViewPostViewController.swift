//
//  ViewPostViewController.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 7/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewPostViewController: UIViewController {
    // Labels + fav button
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    
    // Delete bar button
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var post: Post?
    var userList: [User] = []
    var postList: [Post] = []
    var username: String = ""
    var nameText = ""
    var selectedRow: Int = 0
    var currentUser: String = ""
    var favourite:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set color to buttons
        chatButton.tintColor = UIColor.orange
        orderButton.tintColor = UIColor.orange
        
        // Check if current logged in user is the user that created the post
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                let uidd: String = user.uid
                currentUser = user.uid
                // If current user is not the user who created the post remove edit and delete button
                if (uidd != self.post?.uid) {
                    self.navigationItem.rightBarButtonItems = nil
                }
                else {
                    // Hide follow btn + order btn if user and post creator is the same
                    favouriteButton.isHidden = true
                }
            }
        }
        checkIfFollowedPost()
        loadPosts()
    }
    
    // Function that loads data from Firestore and refreshes tableView
    func loadPosts() {
        DataManager.loadPosts ()
        {
            postListFromFirestore in

            // Assign list to list from Firestore
            self.postList = postListFromFirestore
            
            // For edit, set labels to new edited data
            self.titleLabel.text = self.postList[self.selectedRow].title
            self.priceLabel.text = "$" + String(self.postList[self.selectedRow].price)
            self.postImageView.image = self.postList[self.selectedRow].thumbnail.getImage()
            self.timeLabel.text = self.postList[self.selectedRow].startTime + " to " + self.postList[self.selectedRow].endTime
            self.descLabel.text = self.postList[self.selectedRow].desc
            self.categoryLabel.text = self.postList[self.selectedRow].category
            
            self.post?.title = self.postList[self.selectedRow].title
            self.post?.price = self.postList[self.selectedRow].price
            self.post?.thumbnail = self.postList[self.selectedRow].thumbnail
            self.post?.startTime = self.postList[self.selectedRow].startTime
            self.post?.endTime = self.postList[self.selectedRow].endTime
            self.post?.desc = self.postList[self.selectedRow].desc
            self.post?.category = self.postList[self.selectedRow].category
            
            self.compareTime()
        }
    }
    
    func compareTime() {
        // Check if time is beyond or before current time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600 * 8)

        // Convert start and end time to date
        let startingTime = dateFormatter.date(from: self.post!.startTime)
        let endingTime = dateFormatter.date(from: self.post!.endTime)
        
        // Get current date
        let now = dateFormatter.date(from: dateFormatter.string(from: Date()))

        // Compare timing
        if startingTime?.compare(now!) == .orderedAscending {
            if endingTime?.compare(now!) == .orderedAscending {
                // Disable order button if beyond
                self.orderButton.isHidden = true
            }
            else {
                // Enable if still within time period
                self.orderButton.isHidden = false
            }
        }
        else {
            // Disable order button if beyond
            self.orderButton.isHidden = true
        }
    }
    
    // check if the logged in user has a record that they followed this post
    func checkIfFollowedPost() {

        DataManager.retrieveRecipeAndPosttFollowData(followeruid: currentUser, following: post!.id, type: "post") { (result) in
            let documentFound: Bool = result
            
            if documentFound
            {
                // if record found, change button image to filld heart
                self.favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.favourite = true
            }
            else
            {
                // just in case
                // if record not found, change button image to hollow heart
                self.favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                self.favourite = false
            }
        }
    }
    
    // This function is triggered when the view is about to appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        titleLabel.text = post?.title
        postImageView.image = post?.thumbnail.getImage()
        DataManager.loadUser() {
            userListFromFirestore in
            self.userList = userListFromFirestore
            for i in self.userList {
                if (i.uid == self.post?.uid) {
                    self.usernameLabel.text = i.username
                }
            }
        }
        
        if post?.price != nil {
            priceLabel.text = "$\(post!.price)"
        }
        else {
            priceLabel.text = "Not available"
        }
        
        if post?.startTime != nil {
            if post?.endTime != nil {
                // Set label
                timeLabel.text = post!.startTime + " to " + post!.endTime
                
                compareTime()
            }
            else {
                timeLabel.text = "Not available"
            }
        }
        else {
            timeLabel.text = "Not available"
        }
        
        descLabel.text = post?.desc
        categoryLabel.text = post?.category
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        compareTime()
    }
    
    // Click on trash icon
    @IBAction func deleteButtonPressed(_ sender: Any) {
        // Alert controller
        let alertController = UIAlertController(title: "Delete Post", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
               
        // Confirm action
        let confirm = UIAlertAction(title: "Delete", style: .destructive) {
            (action:UIAlertAction!) in
            
            // Delete post
            DataManager.deletePost(self.post!)
            
            // Reload post in tableView
            let viewControllers = self.navigationController?.viewControllers
            let parent = viewControllers?[0] as! PostsTableViewController
            parent.loadPosts()
            
            // Go back to tableView
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(confirm)
               
        // Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
            (action:UIAlertAction!) in
            
            print("Delete post cancelled");
        }
        alertController.addAction(cancel)
               
        // Present alertController
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    // activate when follow button is pressed
    @IBAction func FavouriteButtonPressed(_ sender: UIButton) {
        
        if favourite == false
        {
            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favourite = true
            DataManager.insertRecipeAndPosttFollowData(followeruid: currentUser, following: post!.id, type: "post")
            
        }
        else
        {
            favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favourite = false
            DataManager.deleteRecipeAndPosttFollowData(followeruid: currentUser, following: post!.id, type: "post")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   
    @IBAction func OrderNavigation(_ sender: Any) {
        nameText = titleLabel.text!
        performSegue(withIdentifier: "orderreq", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditPost")
        {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            let editPostViewController = segue.destination as! EditPostViewController
            if (post != nil) {
                // Set the post object to selected post
                let currentPost = post!
                editPostViewController.post = currentPost
            }
        }
        
        if (segue.identifier == "orderreq"){
            let vc = segue.destination as! OrderReqViewController
            vc.finalName = self.nameText
        }
    }
}
