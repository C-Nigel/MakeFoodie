//
//  SignupViewController.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 1/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    var user : [User] = []
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var dobInput: UITextField!
    
    @IBOutlet weak var genderInput: UISegmentedControl!
    
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var confirmpasswordInput: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    @IBAction func CreateAcc(_ sender: Any) {
        
        let email: String = emailInput.text!

            showToast(controller: self, message: email, seconds: 3)
      
        
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double){
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated: true)
        }
    }
    


}
