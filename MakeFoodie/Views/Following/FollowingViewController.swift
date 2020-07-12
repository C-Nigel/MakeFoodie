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
    var followList : [followDetails] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadFollowItems()
    }
    
    // This is a function that the UITableViewDataSource
    // should implement. It tells the UITableView how many
    // rows there will be.
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    return followList.count
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
        let p = followList[indexPath.row]
        cell.titleLabel.text = p.title
        cell.usernameLabel.text = p.uid
        cell.pictureImageView.image = p.thumbnail.getImage()

        return cell
        }
    
    func loadFollowItems()
    {
        DataManager.loadFollowPostItems()
        {
            itemListFromFirestore in
            
            // This is a closure
            
            // This block of codes is executed when the async loading from Firestore is complete.
            // What it is to reassigned the new list loaded from Firestore.
            
            self.followList = itemListFromFirestore
            
            //Once done, call on the Table View to reload all its contents
            
            self.tableView.reloadData()
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
