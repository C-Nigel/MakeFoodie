//
//  OrderReqViewController.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 13/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class OrderReqViewController: UIViewController {
    var namee: String = "";
    var postList: [Post] = [];
    let VC = ViewPostViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        namee = VC.titleLabel.text!
        DataManager.loadPosts ()
        {
            postListFromFirestore in

            // Assign list to list from Firestore
            self.postList = postListFromFirestore
            for i in self.postList{
                if i.title == self.namee{
                    
                }
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

}
