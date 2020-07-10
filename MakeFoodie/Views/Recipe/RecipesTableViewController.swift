//
//  RecipesTableViewController.swift
//  MakeFoodie
//
//  Created by M06-3 on 7/10/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class RecipesTableViewController: UITableViewController {

    @IBOutlet var recipeTableView: UITableView!
    var recipeList: Array<Recipe> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadRecipes()
    }
    
    //load recipes
    func loadRecipes() {
        DataManager.loadRecipes() {
            recipeListFromFirestore in

            // This is a closure.
            //
            // This block of codes is executed when the // async loading from Firestore is complete.
            // What it is to reassigned the new list loaded
            // from Firestore. //
            self.recipeList = recipeListFromFirestore
            print("recipelist", self.recipeList)

            self.recipeTableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeItem", for: indexPath) as! RecipeTableViewCell

        let r = recipeList[indexPath.row]
        cell.titleLabel.text = r.title
        cell.thumbnailImage.image = r.thumbnail.getImage()
        
        if (r.reviews == []) {
            cell.ratingLabel.text = "-"
        }
        else {
            var totalRating: Int = 0
            var avgRating: Int
            for i in r.reviews {
                totalRating += Int(i[1])!
            }
            avgRating = totalRating/r.reviews.count
            
            cell.ratingLabel.text = String(avgRating)
        }
        
        cell.descLabel.text = r.desc
        cell.usernameLabel.text = r.username
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
