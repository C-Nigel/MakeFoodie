//
//  ProfileViewController.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 8/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imagey: UIImageView!
    @IBOutlet weak var followersNo: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var RecipesNo: UIButton!
    @IBOutlet weak var postsNo: UIButton!
    @IBOutlet weak var descriptions: UITextView!
    
    var userList : [User] = [];
    var followList : [Follow] = [];
    var visitorUID : String = "";
    var favourite:Bool = false
    var recipeList: [Recipe] = [];
    var postList: [Post] = [];
    func checkIfFollowedUser() {

        DataManager.retrieveRecipeAndPosttFollowData(followeruid: Auth.auth().currentUser!.uid, following: visitorUID, type: "user") { (result) in
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if Auth.auth().currentUser != nil{
            let user = Auth.auth().currentUser
            if let user = user {
                if visitorUID != ""
                {
                    if visitorUID == Auth.auth().currentUser?.uid
                    {
                        self.favouriteButton.isHidden = true
                    }
                    checkIfFollowedUser()
                    self.navigationItem.setRightBarButton(nil, animated: true)
                    self.navigationItem.setLeftBarButton(nil, animated: true)
                    DataManager.loadUser(){
                        userListFromFirestore in
                        self.userList = userListFromFirestore
                        for i in self.userList{
                            if i.uid == self.visitorUID{
                                self.username.text = i.username
                                if i.imagelink.getImage() != nil{
                                    self.imagey.image = i.imagelink.getImage()
                                }
                                self.descriptions.text = i.description
                                
                            }
                        }
                    }
                }
                else
                {
                    let uidd: String = user.uid
                    self.favouriteButton.isHidden = true
                    DataManager.loadUser(){
                        userListFromFirestore in
                        self.userList = userListFromFirestore
                        for i in self.userList{
                            if i.uid == uidd{
                                self.username.text = i.username
                                if i.imagelink.getImage() != nil{
                                    self.imagey.image = i.imagelink.getImage()
                                }
                                self.descriptions.text = i.description
                                
                            }
                        }
                    }
                }
                let uidd: String = user.uid
                DataManager.loadFollowers(){
                    followListFromFirestore in
                    self.followList = followListFromFirestore
                    var count: Int = 0;
                    for i in self.followList{
                        if i.followeruid == uidd{
                            count = count + 1;
                        }
                    }
                    self.followersNo.setTitle(String(count), for: .normal)
                }
                DataManager.loadRecipes() {
                    recipeListFromFirestore in
                    self.recipeList = recipeListFromFirestore
                    var count2: Int = 0;
                    for i in self.recipeList{
                        if i.uid == uidd{
                            count2 += 1
                        }
                    }
                    self.RecipesNo.setTitle(String(count2), for: .normal)
                }
                DataManager.loadPosts ()
                {
                    postListFromFirestore in
                    // Assign list to list from Firestore
                    self.postList = postListFromFirestore
                    var count3: Int = 0;
                    for i in self.postList{
                        if i.uid == uidd{
                            count3 += 1
                        }
                    }
                    self.postsNo.setTitle(String(count3), for: .normal)
                }
            }
              
        }
        else{
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }

    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        if favourite == false
        {
            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favourite = true
            DataManager.insertRecipeAndPosttFollowData(followeruid: Auth.auth().currentUser!.uid, following: visitorUID, type: "user")
            
        }
        else
        {
            favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favourite = false
            DataManager.deleteRecipeAndPosttFollowData(followeruid: Auth.auth().currentUser!.uid, following: visitorUID, type: "user")
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    // Do any additional setup after loading the view.
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


