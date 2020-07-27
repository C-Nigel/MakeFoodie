//
//  PostsTableViewController.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 5/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class PostsTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet var postTableView: UITableView!
    @IBOutlet var searchBar: UITableView!
    
    var userList: [User] = []
    var username: String = ""
    var curruid: String = ""
    
    // Create array of all posts for search bar
    var allPostList: [Post] = []
    
    // Array for containing search items
    var postList: [Post] = []
    
    // Check if searching
    var searchUse = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPosts()
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
    
    // Function that loads data from Firestore and refreshes tableView
    func loadPosts() {
        DataManager.loadPosts()
        {
            postListFromFirestore in

            // Assign list to list from Firestore
            self.allPostList = postListFromFirestore

            // Check if list is empty
            if self.allPostList.count == 0 {
                let labelDisplay = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)) // Create label
                labelDisplay.text = "No post has been created" // Set label text
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
            self.postTableView.reloadData()
        }
    }
    
    // Search bar function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Check if searchBar text is empty
        if searchText.isEmpty == false {
            postList = allPostList.filter({(data: Post) -> Bool in
                searchUse = true
                return data.title.range(of: searchText.lowercased(), options: .caseInsensitive) != nil
            })
            // If no post found from search
            if postList.count == 0 {
                let labelDisplay = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)) // Create label
                labelDisplay.text = "No post found" // Set label text
                labelDisplay.textAlignment = .center
                labelDisplay.sizeToFit()
                
                self.tableView.backgroundView = labelDisplay
                self.tableView.separatorStyle = .none   // Remove the lines from tableview
            }
            else {
                self.tableView.backgroundView = nil  // Remove label if present
                self.tableView.separatorStyle = .singleLine // Set lines to tableview
            }
        }
        else {
            postList = allPostList
            searchUse = false
        }

        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.endEditing(true)
    }

    // MARK: - Table view data source

    // Tells the UITableView how many rows there will be.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchUse == true) {
            return postList.count
        }
        else {
            return allPostList.count
        }
    }

    //  To create / reuse a UITableViewCell and return it to the UITableView to draw on the screen.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Query table view to see if there are any UITableViewCells that can be reused. iOS will create a new one if there aren't any.
        let cell : PostCell = tableView.dequeueReusableCell (withIdentifier: "PostCell", for: indexPath) as! PostCell

        // Use the reused cell/newly created cell and update it
        var p = allPostList[indexPath.row]
        if searchUse == true {
            p = postList[indexPath.row]
        }
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
                if (searchUse == true) {
                    let post = postList[myIndexPath!.row]
                    // Pass index based on allPostList and postList matching id
                    viewPostViewController.selectedRow = allPostList.firstIndex(where: { $0.id == post.id })!
                    viewPostViewController.post = post
                }
                else {
                    let post = allPostList[myIndexPath!.row]
                    viewPostViewController.selectedRow = myIndexPath!.row
                    viewPostViewController.post = post
                }
            }
        }
    }
}
