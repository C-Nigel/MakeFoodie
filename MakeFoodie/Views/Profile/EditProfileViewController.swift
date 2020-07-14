//
//  EditProfileViewController.swift
//  MakeFoodie
//
//  Created by 180527E  on 7/10/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var uiddd: UITextField!
    @IBOutlet var descriptions: UITextView!
    
    @IBOutlet weak var dobs: UITextField!
    @IBOutlet weak var emails: UILabel!
    @IBOutlet weak var genders: UISegmentedControl!
    @IBOutlet weak var errormsg: UITextView!
    
    @IBOutlet weak var phoneno: UITextField!
    private var datePicker: UIDatePicker?
    var userList : [User] = [];
    var newlist : [User] = [];
    var errory: Int = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dobs.delegate = self
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(SignupViewController.dateChanged(datePicker:)), for: .valueChanged)
        dobs.inputView = datePicker
        if Auth.auth().currentUser != nil{
            let user = Auth.auth().currentUser
            if let user = user {
              
                let uidd: String = user.uid
                uiddd.text = user.uid
                uiddd.isHidden = true
                DataManager.loadUser(){
                    userListFromFirestore in
                    self.userList = userListFromFirestore
                    for i in self.userList{
                        if i.uid == uidd{
                            self.username.text = i.username
                            self.descriptions.text = i.description
                            if i.imagelink.getImage() != nil{
                                self.Image.image = i.imagelink.getImage()
                            }
                            
                            self.emails.text = user.email
                            if i.gender == "Male"{
                                self.genders.selectedSegmentIndex = 0
                            
                            }
                            else{
                                self.genders.selectedSegmentIndex = 1
                            }
                            self.phoneno.text = i.phoneNo
                            self.dobs.text = i.dob
                            
                        }
                    }
                }
            }
              
        }
        else{
            
        }
    }
    @objc func dateChanged(datePicker: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        dobs.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    @IBAction func OpenImageGallery(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true // Allows editing of image
        picker.sourceType = .photoLibrary // Use image from library
        self.present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage : UIImage = info[.editedImage] as! UIImage
        self.Image.isHidden = false // Ensure imageView is not hidden after selection
        self.Image!.image = chosenImage
    
        UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil) // Save the image selected/taken by user

        picker.dismiss(animated: true) // Close picker
    }
    
    //when user cancel image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    
    public func validateName(name: String) ->Bool {
       // Length be 18 characters max and 3 characters minimum, you can always modify.
       let nameRegex = "^\\w{3,10}$"
       let trimmedString = name.trimmingCharacters(in: .whitespaces)
       let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
       let isValidateName = validateName.evaluate(with: trimmedString)
       return isValidateName
    }
    public func validatePhoneNumber(phoneNumber: String) -> Bool {
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
    
    @IBAction func update(_ sender: Any) {
        errormsg.isHidden = true
        errory = 0;
        var Gender: String = ""
        if self.genders.selectedSegmentIndex == 0{
            Gender = "Male"
        }
        else{
            Gender = "Female"
        }
        if username.text == ""{
            let alert = UIAlertController(
             title: "Username cannot be empty", message: "",
            preferredStyle:
            .alert)
             alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))

             self.present(alert, animated: true, completion: nil)
             return
        }
        if username.text != ""{
            let isValidateName = validateName(name: username.text!)
            if (isValidateName == false) {
               print("Length be 10 characters max and 3 characters minimum")
                errormsg.text = errormsg.text + "Length be 10 characters max and 3 characters minimum" + "\n"
                errory = errory + 1
            }
        }
        if dobs.text != ""{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"

            if dateFormatter.date(from: dobs.text!) == nil {
                print("date is invalid")

                errormsg.text = errormsg.text + "Date must be in dd/MM/yyyy" + "\n"
                errory = errory + 1
            }
        }
        if phoneno.text != ""{
            let isValidatePhoneNumber = validatePhoneNumber(phoneNumber: phoneno.text!)
            if (isValidatePhoneNumber == false) {
               print("Invalid Phone Number")
                errormsg.text = errormsg.text + "Invalid Phone Number" + "\n"
                errory = errory + 1
            }
        }
        
        if errory > 0{
            errormsg.isHidden = false
        }
        else{
            self.newlist.append(User(username: self.username.text!, dob: self.dobs.text!, gender: Gender, phoneNo: phoneno.text!, description: descriptions.text!, imagelink: User.Image.init(withImage: Image.image!), uid: uiddd.text!))
            for i in self.newlist{
                print(i.username);
                print(i.dob);
                print(i.gender)
                 /*db.collection("user").addDocument(data: ["username":i.username, "dob":i.dob, "gender":gender, "phoneNo":"", "description":"",  "uid": i.uid])*/
                
                DataManager.insertOrReplaceUser(i)
                //self.movetologinpage()
        }
        
               
                     
            }
    }
    //when user click select pic
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
