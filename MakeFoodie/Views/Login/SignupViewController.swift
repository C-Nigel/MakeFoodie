//
//  SignupViewController.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 1/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    var user : [User] = []
  
    
  
    
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var dobInput: UITextField!
    @IBOutlet weak var genderInput: UISegmentedControl!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var confirmpasswordInput: UITextField!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.dobInput?.delegate = self

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var oneVC: Signup1ViewController = segue.destination as! Signup1ViewController
        
        var emailss: String = oneVC.getemail
    }*/
    
    
    @IBAction func CreateAccount(_ sender: Any) {
        //let email = dobInput.text
       var gender: String = "";
       if usernameInput.text == "" || dobInput.text == "" || passwordInput.text == "" || confirmpasswordInput.text == ""{
           let alert = UIAlertController(
            title: "Please enter all input fields", message: "",
           preferredStyle:
           .alert)
            alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))

            self.present(alert, animated: true, completion: nil)
            return
       }
       if genderInput.selectedSegmentIndex == 0{
           gender = "Male"
       }
       else{
           gender = "Female"
       }
       
       user.append(User(email: emailInput.text!, username: usernameInput.text!, dob: dobInput.text!, gender: gender, phoneNo: "", password: passwordInput.text!))
       for i in user{
           print(i.username);
           print(i.dob);
           print(i.email);
           print(i.password)
           print(i.gender)
           
           
       }
        DataManager.insertOrReplaceMovie(user)
            
    }
    
    
    //Hide keyboard when user touch outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //Hide keyboard when user press return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dobInput.resignFirstResponder()
        return(true)
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
