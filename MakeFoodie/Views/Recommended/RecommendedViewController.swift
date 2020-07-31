//
//  RecommendedViewController.swift
//  MakeFoodie
//
//  Created by NIgel Cheong on 10/6/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class RecommendedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let p = itemList[indexPath.row]
        DataManager.getUsernameByUID(uid: p.uid) { (usernme) in
            cell.titleLabel.text = p.title
    //        cell.itemImageView.image = UIImage(named: p.imageName)
            cell.itemImageView.image = p.thumbnail.getImage()
            cell.usernameLabel.text = usernme
            cell.priceLabel.text = "$ \(p.price)"
            cell.descriptionLabel.text = p.desc
        }
        
        return cell
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPostDetails")
        {
            let nav = segue.destination as! UINavigationController
            let viewPostViewController = nav.topViewController as! ViewPostViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            
            if(myIndexPath != nil) {
             // Set the movieItem field with the movie
            // object selected by the user.
            //
//                print(myIndexPath!.section)
//                print(myIndexPath!.row)
                let post = itemList[myIndexPath!.row]
                viewPostViewController.post = post
                viewPostViewController.currPostId = post.id
            }
        }
    }
    
    var refreshControl = UIRefreshControl()
    var itemList : [Post] = []
    
    func loadRecommendedItems(onComplete: @escaping (_ status: String) -> ())
    {
        DataManager.loadRecomendedItems()
        {
            itemListFromFirestore in
            
            // This is a closure
            
            // This block of codes is executed when the async loading from Firestore is complete.
            // What it is to reassigned the new list loaded from Firestore.
            
            self.itemList = itemListFromFirestore
            
            //Once done, call on the Table View to reload all its contents
            
            self.tableView.reloadData()
            onComplete("Done")
        }
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadRecommendedItems { (status) in
            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
            self.tableView.addSubview(self.refreshControl)
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        loadRecommendedItems { (Status) in
            self.refreshControl.endRefreshing()
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
