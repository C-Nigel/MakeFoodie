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

class RecipesTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var noRecipesFound: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var recipeTableView: UITableView!
    var recipeList: Array<Recipe> = []
    var userList: Array<User> = []
    var username: String = ""
    var uid: String = ""
    var curruid: String = ""
    
    var filteredRecipes: Array<Recipe> = []
    var isSearchBarEmpty: Bool {
        return self.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return !isSearchBarEmpty
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                let uidd: String = user.uid
                DataManager.loadUser() {
                    userListFromFirestore in
                    self.userList = userListFromFirestore
                    for i in self.userList {
                        if (i.uid == uidd) {
                            self.username = i.username
                            self.curruid = i.uid
                        }
                    }
                }
            }
        }
        else {
        }

        //set search bar placeholder and delegate
        searchBar.placeholder = "Search Recipes"
        searchBar.delegate = self
        
        //set background view of tableview to no recipes found view
        self.recipeTableView.backgroundView = self.noRecipesFound
        
        self.recipeTableView.delegate = self
        self.recipeTableView.dataSource = self
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
            //reload tableView
            self.recipeTableView.reloadData()
        }
    }
    
      
    //for search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredRecipes = self.recipeList.filter { (recipe: Recipe) -> Bool in
            return recipe.title.lowercased().contains(searchText.lowercased())
        }
        
        //if filtered is empty (no matching searches)
        if (self.filteredRecipes.isEmpty) {
            //hide separator lines
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if searching
        if isFiltering {
          return filteredRecipes.count
        }
        
        return recipeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeItem", for: indexPath) as! RecipeTableViewCell
        
        let r: Recipe
        
        //if searching
        if isFiltering {
            //assign r as filteredRecipes rows
            r = self.filteredRecipes[indexPath.row]
        }
        else { //if not
            //assign r as recipeList rows
            r = self.recipeList[indexPath.row]
        }

        cell.titleLabel.text = r.title
        cell.thumbnailImage.image = r.thumbnail.getImage()
        
        if (r.reviews.isEmpty) {
            cell.ratingLabel.text = "-"
        }
        else {
            var totalRating: Int = 0
            var avgRating: Float
            for i in r.reviews.keys {
                totalRating += Int(r.reviews[i]!["Rating"]!)!
            }
            avgRating = Float(totalRating)/Float(r.reviews.count)
            
            cell.ratingLabel.text = String(format: "%.1f", avgRating)
        }
        
        cell.descLabel.text = r.desc
        
        DataManager.loadUser() {
            userListFromFirestore in
            self.userList = userListFromFirestore
            for i in self.userList {
                if (i.uid == r.uid) {
                    cell.usernameLabel.text = i.username
                }
            }
        }

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
    
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
    }*/

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "viewRecipeDetails") {
            let destView = segue.destination as! RecipeDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let recipe = recipeList[myIndexPath!.row]
            
            destView.recipeList = self.recipeList
            destView.curruid = self.curruid
            destView.recipe = recipe
        }
        if (segue.identifier == "createRecipeFromTable") {
            let destView = segue.destination as! RecipeDetailViewController

            destView.curruid = self.curruid
        }
    }
    

}
