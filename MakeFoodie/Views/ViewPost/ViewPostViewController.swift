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
            }
        }
    }
    
    // This function is triggered when the view is about to appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

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
        priceLabel.text = "$\(post!.price)"
        descLabel.text = post?.desc
        categoryLabel.text = post?.category
        
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   
    @IBAction func OrderNavigation(_ sender: Any) {
        nameText = titleLabel.text!
        performSegue(withIdentifier: "orderreq", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if (segue.identifier == "ShowPostDetails")
           {
               // Get the new view controller using segue.destination.
               // Pass the selected object to the new view controller.
               let editPostViewController = segue.destination as! EditPostViewController
           }
        if (segue.identifier == "orderreq"){
            let vc = segue.destination as! OrderReqViewController
            vc.finalName = self.nameText
        }
            
       }
    
    
}
