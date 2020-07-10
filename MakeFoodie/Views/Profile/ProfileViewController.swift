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
    
    var userList : [User] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if Auth.auth().currentUser != nil{
            let user = Auth.auth().currentUser
            if let user = user {
              // The user's ID, unique to the Firebase project.
              // Do NOT use this value to authenticate with your backend server,
              // if you have one. Use getTokenWithCompletion:completion: instead.
                let uidd: String = user.uid
                /*let db = Firestore.firestore()
                db.collection("user").getDocuments { (data, err) in
                    var userList : [User] = []
                    if err != nil{
                        print("Error getting data")
                    }
                    else{
                        for document in data!.documents{
                            let userss = try? document.data(as: User.self)!
                            if userss != nil{
                                userList.append(userss!)
                                for i in userList{
                                    if i.uid == uidd{
                                        
                                        self.username.text = i.username
                                        
                                    }
                                }
                            }
                        }
                    }
                }*/
                DataManager.loadUser(){
                    userListFromFirestore in
                    self.userList = userListFromFirestore
                    for i in self.userList{
                        if i.uid == uidd{
                            self.username.text = i.username
                        }
                    }
                }
            }
              //let email = user.email
              
             
              // ...
        }
        else{
            
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


