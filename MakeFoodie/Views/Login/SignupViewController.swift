//
//  SignupViewController.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 1/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    var user : [User] = []
    
  
    
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var dobInput: UITextField!
    @IBOutlet weak var genderInput: UISegmentedControl!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var confirmpasswordInput: UITextField!
    
    private var datePicker: UIDatePicker?
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.dobInput.delegate = self
        //CHANGE BORDER OF INPUT FIELDS TO BLACK
        let myColor = UIColor.black
        emailInput.layer.borderColor = myColor.cgColor
        usernameInput.layer.borderColor = myColor.cgColor
        dobInput.layer.borderColor = myColor.cgColor
        passwordInput.layer.borderColor = myColor.cgColor
        confirmpasswordInput.layer.borderColor = myColor.cgColor
        emailInput.layer.borderWidth = 1.0
        usernameInput.layer.borderWidth = 1.0
        dobInput.layer.borderWidth = 1.0
        passwordInput.layer.borderWidth = 1.0
        confirmpasswordInput.layer.borderWidth = 1.0
        //DATE PICKER WHEN DOB INPUT IS CLICKED
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(SignupViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        //TAP GESTURE WHEN TAPPED WILL CLOSE PICKER
        /*let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)*/
        
        dobInput.inputView = datePicker
        // Do any additional setup after loading the view.
    }
    
    /*@objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }*/
    //FORMAT DATE OF PICKER
    @objc func dateChanged(datePicker: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        dobInput.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //VALIDATIONS
    public func validateName(name: String) ->Bool {
       // Length be 18 characters max and 3 characters minimum, you can always modify.
       let nameRegex = "^\\w{3,18}$"
       let trimmedString = name.trimmingCharacters(in: .whitespaces)
       let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
       let isValidateName = validateName.evaluate(with: trimmedString)
       return isValidateName
    }
    public func validaPhoneNumber(phoneNumber: String) -> Bool {
       let phoneNumberRegex = "^[6-9]\\d{9}$"
       let trimmedString = phoneNumber.trimmingCharacters(in: .whitespaces)
       let validatePhone = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
       let isValidPhone = validatePhone.evaluate(with: trimmedString)
       return isValidPhone
    }
    public func validateEmailId(emailID: String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
       let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       let isValidateEmail = validateEmail.evaluate(with: trimmedString)
       return isValidateEmail
    }
    public func validatePassword(password: String) -> Bool {
       //Minimum 8 characters at least 1 Alphabet and 1 Number:
       let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
       let trimmedString = password.trimmingCharacters(in: .whitespaces)
       let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
       let isvalidatePass = validatePassord.evaluate(with: trimmedString)
       return isvalidatePass
    }
    public func validateAnyOtherTextField(otherField: String) -> Bool {
       let otherRegexString = "Your regex String"
       let trimmedString = otherField.trimmingCharacters(in: .whitespaces)
       let validateOtherString = NSPredicate(format: "SELF MATCHES %@", otherRegexString)
       let isValidateOtherString = validateOtherString.evaluate(with: trimmedString)
       return isValidateOtherString
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
    
    //CREATE ACCOUNT BUTTON ACTIONS
    @IBAction func CreateAccount(_ sender: Any) {
        //validate
        guard let name = usernameInput.text, let email = emailInput.text, let password = passwordInput.text
        else {
           return
        }
        if usernameInput.text == "" || dobInput.text == "" || passwordInput.text == "" || confirmpasswordInput.text == ""{
            let alert = UIAlertController(
             title: "Please enter all input fields", message: "",
            preferredStyle:
            .alert)
             alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))

             self.present(alert, animated: true, completion: nil)
             return
        }
        let isValidateName = validateName(name: name)
        if (isValidateName == false) {
           print("Length be 18 characters max and 3 characters minimum")
            
           return
        }
        let isValidateEmail = validateEmailId(emailID: email)
        if (isValidateEmail == false){
           print("Incorrect Email")
            let alert = UIAlertController(
             title: "Please enter all input fields", message: "",
            preferredStyle:
            .alert)
             alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))

             self.present(alert, animated: true, completion: nil)
           return
        }
        let isValidatePass = validatePassword(password: password)
        if (isValidatePass == false) {
           print("Minimum 8 characters at least 1 Alphabet and 1 Number")
           return
        }
        
        
        //let email = dobInput.text
       var gender: String = "";
       
       if genderInput.selectedSegmentIndex == 0{
           gender = "Male"
       }
       else{
           gender = "Female"
       }
       //THROW INPUT IN CLASS ARRAY AND THEN STORE IN DATABASE
        user.append(User(email: emailInput.text!, username: usernameInput.text!, dob: dobInput.text!, gender: gender, phoneNo: "", password: passwordInput.text!, description: ""))
       for i in user{
           print(i.username);
           print(i.dob);
           print(i.email);
           print(i.password)
           print(i.gender)
           
        DataManager.insertOrReplaceUser(i)
       }
        //DataManager.insertOrReplaceMovie(user)
            
    }
    
    
    //Hide keyboard when user touch outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
