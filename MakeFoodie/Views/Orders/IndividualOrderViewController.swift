//
//  IndividualOrderViewController.swift
//  MakeFoodie
//
//  Created by 180527E  on 8/15/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class IndividualOrderViewController: UIViewController {

    @IBOutlet weak var itemimage: UIImageView!
    @IBOutlet weak var itemname: UILabel!
    @IBOutlet weak var itemprice: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var address: UITextView!
    var orderitem : Order?
    var orderuidd: String="";
    var orderList: [Order] = [];
    var newList: [Order] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.loadOrders()
        {
            orderListFromFirestore in
            self.orderList = orderListFromFirestore
            for i in self.orderList{
                if i.orderuid == self.orderuidd{
                    self.itemname.text = i.itemname
                    self.itemprice.text = i.itemprice
                    self.address.text = i.postalcode
                    self.itemimage.image = i.itemimage.getImage()
                    self.quantity.text = i.quantity
          
                }
            }

        }
        
    }
    
    @IBAction func acceptorder(_ sender: Any) {
        DataManager.loadOrders()
        {
            orderListFromFirestore in
            self.orderList = orderListFromFirestore
            for i in self.orderList{
                if i.orderuid == self.orderuidd{
                    self.newList.append(Order(selleruid: i.selleruid, buyeruid: i.buyeruid, itemname: i.itemname, itemimage: Order.Image.init(withImage: self.itemimage.image!),itemprice: self.itemprice.text!, quantity: i.quantity, postalcode: i.postalcode,orderuid: i.orderuid, status: "Accepted"))
                        for i in self.newList{
                            print(i.selleruid);
                            print(i.buyeruid);
                            print(i.itemprice)
                            print(i.status)
                  
                             /*db.collection("user").addDocument(data: ["username":i.username, "dob":i.dob, "gender":gender, "phoneNo":"", "description":"",  "uid": i.uid])*/
                            
                            DataManager.insertOrReplaceOrder(i)
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabbar")
                                    self.present(newViewController, animated: true, completion: nil)
                            //self.movetologinpage()
                    }
                }
            }

        }
    }
    @IBAction func rejectorder(_ sender: Any) {
        DataManager.loadOrders()
        {
            orderListFromFirestore in
            self.orderList = orderListFromFirestore
            for i in self.orderList{
                if i.orderuid == self.orderuidd{
                    self.newList.append(Order(selleruid: i.selleruid, buyeruid: i.buyeruid, itemname: i.itemname, itemimage: Order.Image.init(withImage: self.itemimage.image!),itemprice: self.itemprice.text!, quantity: i.quantity, postalcode: i.postalcode,orderuid: i.orderuid, status: "Rejected"))
                        for i in self.newList{
                            print(i.selleruid);
                            print(i.buyeruid);
                            print(i.itemprice)
                            print(i.status)
                        
                             /*db.collection("user").addDocument(data: ["username":i.username, "dob":i.dob, "gender":gender, "phoneNo":"", "description":"",  "uid": i.uid])*/
                            
                            DataManager.insertOrReplaceOrder(i)
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabbar")
                                    self.present(newViewController, animated: true, completion: nil)
                            //self.movetologinpage()
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
