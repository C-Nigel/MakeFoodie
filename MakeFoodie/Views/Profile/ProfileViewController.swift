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
  
    @IBOutlet weak var descriptions: UITextView!
    
    var userList : [User] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if Auth.auth().currentUser != nil{
            let user = Auth.auth().currentUser
            if let user = user {
              
                let uidd: String = user.uid
                
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
              
        }
        else{
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
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


