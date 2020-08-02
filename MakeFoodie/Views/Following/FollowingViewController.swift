//
//  followingViewController.swift
//  MakeFoodie
//
//  Created by NIgel Cheong on 11/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class FollowingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

     // Declare an array of Movie objects
    var indexSelected : String = "post"
    var postList : [Post] = []
    var recipeList : [recipeDetails] = []
    var followingUserList : [userDetails] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var subView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadFollowItems(type: "post")
        DataManager.getNameByUID()
    }
    
    // This is a function that the UITableViewDataSource
    // should implement. It tells the UITableView how many
    // rows there will be.
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count : Int = 0
        if indexSelected == "post"
        {
            count = postList.count
        }
        else if indexSelected == "recipes"
        {
            count = recipeList.count
        }
        else if indexSelected == "user following"
        {
            count = followingUserList.count
        }
        else if indexSelected == "following user"
        {
            count = followingUserList.count
        }
        
        return count
    }
    
    // This is a function that the UITableViewDataSource
    // must implement. It needs to create / reuse a UITableViewCell
    // and return it to the UITableView to draw on the screen.
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // First we query the table view to see if there are
        // any UITableViewCells that can be reused. iOS will
        // create a new one if there aren't any.
        //
        let cell : FollowCell = tableView
        .dequeueReusableCell (withIdentifier: "FollowCell", for: indexPath)
        as! FollowCell
        // Using the re-used cell, or the newly created
        // cell, we update the text label's text property.
        //
        
        if indexSelected == "post"
        {
            let p = postList[indexPath.row]
            cell.titleLabel.text = p.title
            cell.usernameLabel.text = p.uid
            cell.pictureImageView.image = p.thumbnail.getImage()
        }
        else if indexSelected == "recipes"
        {
            let p = recipeList[indexPath.row]
            cell.titleLabel.text = p.title
            cell.usernameLabel.text = p.uid
            cell.pictureImageView.image = p.thumbnail.getImage()
        }
        else if indexSelected == "user following"
        {
            let p = followingUserList[indexPath.row]
            cell.titleLabel.text = p.username
            cell.usernameLabel.text = p.description
            cell.pictureImageView.image = p.imagelink.getImage()
        }
        
        else if indexSelected == "following user"
        {
            let p = followingUserList[indexPath.row]
            cell.titleLabel.text = p.username
            cell.usernameLabel.text = p.description
            cell.pictureImageView.image = p.imagelink.getImage()
        }

        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexSelected == "post"
//        {
//            print("hi index selected is post")
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Following", bundle: nil)
//            //let nav = storyboard?.instantiateViewController(identifier: "Following") as! UINavigationController
////            let viewController = nav.storyboard?.instantiateViewController(identifier: "viewPostVC") as! ViewPostViewController
//            let viewController = storyBoard.instantiateViewController(identifier: "viewPostVC") as! ViewPostViewController
//            viewController.post = postList[indexPath.row]
//            viewController.currPostId = postList[indexPath.row].id
//            self.present(viewController, animated: true)
//        }
//        else if indexSelected == "recipes"
//        {
//
//        }
//        else if indexSelected == "user following"
//        {
//
//        }
//        else if indexSelected == "following user"
//        {
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexSelected == "post"
                {
                    print("hi index selected is post")
                    performSegue(withIdentifier: "ViewPostVC", sender: Any?.self)
                }
                else if indexSelected == "recipes"
                {
        
                }
                else if indexSelected == "user following"
                {
        
                }
                else if indexSelected == "following user"
                {
        
                }
    }
    
    @IBAction func segmentedControlChangedIndex(_ sender: Any)
    {
        switch segmentedControl.selectedSegmentIndex
        {
            case 0:
                loadFollowItems(type: "post")
                indexSelected = "post"
            case 1:
                loadFollowItems(type: "recipes")
                indexSelected = "recipes"
            case 2:
                loadFollowItems(type: "user following")
                indexSelected = "user following"
            case 3:
                loadFollowItems(type: "following user")
                indexSelected = "following user"
            default:
                break
        }
    }
    
    func loadFollowItems(type: String)
    {
        if type == "post"
        {
            self.subView.isHidden = false
            DataManager.loadFollowPostItems()
            {
                itemListFromFirestore in
                self.subView.isHidden = true
                // This is a closure
                
                // This block of codes is executed when the async loading from Firestore is complete.
                // What it is to reassigned the new list loaded from Firestore.
                
                self.postList = itemListFromFirestore
                
                //Once done, call on the Table View to reload all its contents
                
                self.tableView.reloadData()
            }
        }
        else if type == "recipes"
        {
            self.subView.isHidden = false
            DataManager.loadFollowRecipeItems()
            {
                itemListFromFirestore in
                self.subView.isHidden = true
                // This is a closure
                
                // This block of codes is executed when the async loading from Firestore is complete.
                // What it is to reassigned the new list loaded from Firestore.
                
                self.recipeList = itemListFromFirestore
                
                //Once done, call on the Table View to reload all its contents
                
                self.tableView.reloadData()
            }
        }
        else if type == "user following"
        {
            self.subView.isHidden = false
            DataManager.loadFollowingUserItems()
            {
                itemListFromFirestore in
                self.subView.isHidden = true
                // This is a closure
                
                // This block of codes is executed when the async loading from Firestore is complete.
                // What it is to reassigned the new list loaded from Firestore.
                
                self.followingUserList = itemListFromFirestore
                
                //Once done, call on the Table View to reload all its contents
                
                self.tableView.reloadData()
            }
        }
        else if type == "following user"
        {
            self.subView.isHidden = false
            DataManager.loadUserFollowingItems()
            {
                itemListFromFirestore in
                self.subView.isHidden = true
                
                // This is a closure
                
                // This block of codes is executed when the async loading from Firestore is complete.
                // What it is to reassigned the new list loaded from Firestore.
                
                self.followingUserList = itemListFromFirestore
                
                //Once done, call on the Table View to reload all its contents
                
                self.tableView.reloadData()
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
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ViewPostVC")
        {
            let nav = segue.destination as! UINavigationController
            let viewPostViewController = nav.topViewController as! ViewPostViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            
            if(myIndexPath != nil) {
             // Set the movieItem field with the movie
            // object selected by the user.
            //
                print(myIndexPath!.section)
                print(myIndexPath!.row)
                let post = postList[myIndexPath!.row]
                viewPostViewController.post = post
                viewPostViewController.currPostId = post.id
            }
        }
    }

}
