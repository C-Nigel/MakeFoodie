//
//  OrdersViewController.swift
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


class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var orderList: [Order] = [];
    var listy: [Order] = [];

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //tableView.register(OrderCell.self, forCellReuseIdentifier: "OrderCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        let p = orderList[indexPath.row]
        print(p.itemname)
        print(p.itemprice)
        cell.itemname.text = p.itemname
        cell.price.text = p.itemprice
        cell.itemimage.image = p.itemimage.getImage()
        cell.orderuidlb.text = p.orderuid
        return cell
    }
    func loadOrders()
    {
        DataManager.loadOrdersBasedOnUID()
        {
            orderListFromFirestore in
            
            
            self.orderList = orderListFromFirestore
        
            
            self.tableView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showorder"){
            let detailViewController = segue.destination as! IndividualOrderViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            if(myIndexPath != nil) {
                // Set the post object to selected post

                let order = orderList[myIndexPath!.row]
                // Pass id to get the post
                detailViewController.orderuidd = order.orderuid


                
            }
        
        }
     }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadOrders()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad()
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
