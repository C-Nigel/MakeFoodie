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
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    
    // Delete bar button
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var post: Post?
    var userList:[User] = []
    var username: String = ""
    var nameText = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if current logged in user is the user that created the post
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                let uidd: String = user.uid
                // If current user is not the user who created the post remove edit and delete button
                if (uidd != self.post?.uid) {
                    self.navigationItem.rightBarButtonItems = nil
                }
                else {
                    favouriteButton.isHidden = true
                }
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
        
        descLabel.text = post?.desc
        categoryLabel.text = post?.category
        
        
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
