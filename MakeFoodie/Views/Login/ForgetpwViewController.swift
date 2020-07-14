//
//  ForgetpwViewController.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 13/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class ForgetpwViewController: UIViewController {

    @IBOutlet weak var emailinput: UITextField!
    @IBOutlet weak var sendemail: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendemail.backgroundColor = UIColor.orange
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendemail(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailinput.text!) { (error) in
            if error != nil{
                print("Error sending email!")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
