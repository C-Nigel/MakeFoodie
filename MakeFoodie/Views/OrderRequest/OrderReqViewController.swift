//
//  OrderReqViewController.swift
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

class OrderReqViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var namee: String = "";
    var postList: [Post] = [];
    var posty: Post?
    let VC = ViewPostViewController()
    var finalName = ""
    var newlist: [Order] = [];
    var userList: [User] = [];
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var sellername: UILabel!
    @IBOutlet weak var itemname: UILabel!
    @IBOutlet weak var itemprice: UILabel!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var dropdown: UIPickerView!
    @IBOutlet weak var itemimage: UIImageView!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var deliveryfee: UILabel!
    @IBOutlet weak var totalamt: UILabel!
    @IBOutlet weak var addresses: UITextField!
    
    var list = ["1", "2", "3", "4", "5"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myColor = UIColor.black
        view1.layer.borderColor = myColor.cgColor
        view1.layer.borderWidth = 1.0
        view2.layer.borderColor = myColor.cgColor
        view2.layer.borderWidth = 1.0
        view3.layer.borderColor = myColor.cgColor
        view3.layer.borderWidth = 1.0
        view4.layer.borderColor = myColor.cgColor
        view4.layer.borderWidth = 1.0
        view5.layer.borderColor = myColor.cgColor
        view5.layer.borderWidth = 1.0

        quantity.inputView = UIView()
        DataManager.loadPosts ()
        {
            postListFromFirestore in

            // Assign list to list from Firestore
            self.postList = postListFromFirestore
            for i in self.postList{
                if i.title == self.finalName{
                    self.quantity.text = "1"
                    self.itemname.text = i.title
                    self.itemprice.text = "\(Double(i.price))"
                    self.itemimage.image = i.thumbnail.getImage()
                    self.subtotal.text = "\(i.price)"
                    self.deliveryfee.text = "2"
                    self.totalamt.text = "\(Double(i.price + 2))"
                    DataManager.getUsernameByUID(uid: i.uid) { (username) in
                        self.sellername.text = username
                    }
                    
                }
            }
            

        }
        /*itemname.text = posty?.title
        itemprice.text = "$\(posty?.price)"
        itemimage.image = posty?.thumbnail.getImage()*/
        // Do any additional setup after loading the view.
       
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
       return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

       return list.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

       self.view.endEditing(true)
       return list[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.quantity.text = self.list[row]
        self.totalamt.text = String((self.subtotal.text! as NSString).floatValue * (self.quantity.text! as NSString).floatValue + (self.deliveryfee.text! as NSString).floatValue)
        self.dropdown.isHidden = true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.quantity{
            self.dropdown.isHidden = false
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    @IBAction func submitorder(_ sender: Any) {
        DataManager.loadUser(){
            userListFromFirestore in
            self.userList = userListFromFirestore
            for i in self.userList{
                if i.username == self.sellername.text{
                    let selleruid: String = i.uid
                    if Auth.auth().currentUser != nil{
                        let user = Auth.auth().currentUser
                        if let user = user {
                          
                            let buyeruid: String = user.uid
                            self.newlist.append(Order(selleruid: selleruid, buyeruid: buyeruid, itemname: self.itemname.text!, itemimage: Order.Image.init(withImage: self.itemimage.image!),itemprice: self.itemprice.text!, address: self.addresses.text!, status: "Pending For Acceptance"))
                                for i in self.newlist{
                                    print(i.selleruid);
                                    print(i.buyeruid);
                                    print(i.itemprice)
                                    print(i.status)
                                    print(i.address)
                                     /*db.collection("user").addDocument(data: ["username":i.username, "dob":i.dob, "gender":gender, "phoneNo":"", "description":"",  "uid": i.uid])*/
                                    
                                    DataManager.insertOrReplaceOrder(i)
                                    //self.movetologinpage()
                            }
                            
                        }
                    }
                    
                    
                    
                }
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
