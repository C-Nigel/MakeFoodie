//
//  LoginViewController.swift
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
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    
    
    var errory: Int = 0;
    var userList: [User] = [];
    var user: [User] = [];
    //declaration
    @IBOutlet weak var emaily: UITextField!
    @IBOutlet weak var passwordy: UITextField!
    @IBOutlet weak var emailerrorimg: UIImageView!
    @IBOutlet weak var emailerror: UILabel!
    @IBOutlet weak var passworderror: UILabel!
    @IBOutlet weak var passworderrorimg: UIImageView!
    @IBOutlet weak var loginbutton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //design
        let myColor = UIColor.black
        loginbutton.backgroundColor = UIColor.orange
        emaily.layer.borderColor = myColor.cgColor
        emaily.layer.borderWidth = 1.0
        passwordy.layer.borderColor = myColor.cgColor
        passwordy.layer.borderWidth = 1.0
        //GOOGLE SIGN IN BUTTON
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 150, y: 600, width: view.frame.width/2, height: 120)
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()

        // Do any additional setup after loading the view.
    }
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
          // ...
            print("Failed to log into Google: ", err)
            return
        }
        print("Successfully logged into Google", user as Any)

        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        // ...
        Auth.auth().signIn(with: credential, completion: { (user2, error) in
            if let err = error {
                print("Failed to create a Firebase User with Google account: ", err)
                return
            }
            if Auth.auth().currentUser != nil{
                let user = Auth.auth().currentUser
                    if let user = user {
                        let uidd = user.uid
                        let email = user.email
                        var num: Int = 0;
                        DataManager.loadUser(){
                            userListFromFirestore in
                            self.userList = userListFromFirestore
                            for i in self.userList{
                                if i.uid == uidd{
                                    num += 1;
                                }
                            }
                            //database of user not available
                            if num == 0{
                                self.user.append(User(username: (email!.components(separatedBy: "@")[0]), dob: "", gender: "", phoneNo: "", description: "", imagelink: User.Image.init(withImage: UIImage()), uid: uidd))
                                for i in self.user{
                                    print(i.username);
                                    print(i.dob);
                                    print(i.gender)
                                     /*db.collection("user").addDocument(data: ["username":i.username, "dob":i.dob, "gender":gender, "phoneNo":"", "description":"",  "uid": i.uid])*/
                                    
                                    DataManager.insertOrReplaceUser(i)
                                }
                            }
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabbar")
                                    self.present(newViewController, animated: true, completion: nil)
                        }
                }
            }
            
            //print("Successfully logged into Firebase with Google", uid)
        })
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    //all validations functions
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
    //when login button pressed
    @IBAction func onLogin(_ sender: Any) {
        emailerrorimg.isHidden = true
        emailerror.isHidden = true
        passworderrorimg.isHidden = true
        passworderror.isHidden = true
        errory = 0;
        guard let email = emaily.text, let password = passwordy.text
        else {
           return
        }
        //if input is empty
        if emaily.text == "" || passwordy.text == ""{
            let alert = UIAlertController(
             title: "Please enter all input fields", message: "",
            preferredStyle:
            .alert)
             alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))

             self.present(alert, animated: true, completion: nil)
             return
        }
        //if email invalid
        let isValidateEmail = validateEmailId(emailID: email)
        if (isValidateEmail == false){
            emailerrorimg.isHidden = false
            emailerror.isHidden = false
            emailerror.text = "Invalid Email"
            print("Incorrect Email")
            
            errory = errory + 1;
           
        }
        //if password invalid
        let isValidatePass = validatePassword(password: password)
        if (isValidatePass == false) {
           print("Minimum 8 characters at least 1 Alphabet and 1 Number")
            passworderrorimg.isHidden = false
            passworderror.isHidden = false
            passworderror.text = "Invalid password"
            errory = errory + 1;
           return
        }
        //if there is no error proceed
        if errory == 0{
            Auth.auth().signIn(withEmail: emaily.text!, password: passwordy.text!) { (result, error) in
                if let x = error {
                    let err = x as NSError
                    switch err.code {
                        //check if
                    case AuthErrorCode.wrongPassword.rawValue:
                        print("wrong password")
                        self.passworderrorimg.isHidden = false
                        self.passworderror.isHidden = false
                        self.passworderror.text = "Invalid password"
                    case AuthErrorCode.invalidEmail.rawValue:
                        print("invalid email")
                        self.emailerrorimg.isHidden = false
                        self.emailerror.isHidden = false
                        self.emailerror.text = "Email Does not exist"
                    
                    
                    default:
                       print("unknown error: \(err.localizedDescription)")
                    }
                
                }
                else{
                    // if no error then navigate to home page
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabbar")
                            self.present(newViewController, animated: true, completion: nil)
                }
                
                
            }
        }
        
        
        
    }
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
