//
//  ViewCategoryTableViewController.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 7/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ViewCategoryTableViewController: UITableViewController {
    @IBOutlet var viewCategoryTableView: UITableView!
    var viewCategoryTitle: String = ""
    var postList: [Post] = []   // Contain post of chosen category
    var userList: [User] = []
    var username: String = ""
    var curruid: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title of viewController to be the selected category name
        self.title = viewCategoryTitle
        loadPostsByCategory(viewCategoryTitle)
    }
    
    // This function is triggered when the view is about to appear.
    override func viewWillAppear(_ animated: Bool) {
        // Check username
        if Auth.auth().currentUser != nil {
            // Get the current user
            let user = Auth.auth().currentUser
            if let user = user {
                // Get current user id
                let uidd: String = user.uid
                DataManager.loadUser() {
                    userListFromFirestore in
                    self.userList = userListFromFirestore
                    for i in self.userList {
                        // Get current user's user name and save user id
                        if (i.uid == uidd) {
                            self.username = i.username
                            self.curruid = i.uid
                        }
                    }
                }
            }
        }
    }
    
    // Called when the view is visible
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Deselect selected row
        let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow {
            tableView.deselectRow(at: selectedRowNotNill, animated: true)
        }
    }
    
    // Function that loads data based on category from Firestore and refreshes tableView
    func loadPostsByCategory(_ category:String) {
        DataManager.loadPostsByCategory(category)
        {
            postListFromFirestore in

            // Assign list to list from Firestore
            self.postList = postListFromFirestore

            // Check if list is empty
            if self.postList.count == 0 {
                let labelDisplay = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)) // Create label
                labelDisplay.text = "No posts under this category" // Set label text
                labelDisplay.textAlignment = .center
                labelDisplay.sizeToFit()
                
                self.tableView.backgroundView = labelDisplay
                self.tableView.separatorStyle = .none   // Remove the lines from tableview
            }
            else {
                self.tableView.backgroundView = nil  // Remove label if present
                self.tableView.separatorStyle = .singleLine // Set lines to tableview
            }
            
            // Reload content in tableView
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ViewCategoryCell = tableView.dequeueReusableCell (withIdentifier: "ViewCategoryCell", for: indexPath) as! ViewCategoryCell

        // Use the reused cell/newly created cell and update it
        let p = postList[indexPath.row]
        cell.titleLabel.text = p.title
        cell.titleLabel.sizeToFit()
        cell.postImageView.image = p.thumbnail.getImage()
        cell.priceLabel.text = "$\(p.price)"
        cell.descLabel.text = p.desc
        
        DataManager.loadUser() {
            userListFromFirestore in
            self.userList = userListFromFirestore
            for i in self.userList {
                if (i.uid == p.uid) {
                    cell.usernameLabel.text = i.username
                }
            }
        }
        cell.usernameLabel.sizeToFit()
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowPostDetails")
        {
            // Get the new view controller using segue.destination.
            let viewPostViewController = segue.destination as! ViewPostViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            if(myIndexPath != nil) {
                // Set the post object to selected post
                let post = postList[myIndexPath!.row]
                viewPostViewController.currPostId = post.id
                viewPostViewController.post = post
            }
        }
    }
}
