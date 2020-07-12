//
//  RecipeDetailViewController.swift
//  MakeFoodie
//
//  Created by M06-3 on 7/11/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RecipeDetailViewController: UIViewController {
    
    //labels for recipe
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var ingLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    
    //add review button
    @IBOutlet weak var addReviewButton: UIButton!
    
    //current user review
    @IBOutlet weak var yourReviewStack: UIStackView!
    @IBOutlet weak var yourUsernameLabel: UILabel!
    @IBOutlet weak var yourRatingLabel: UILabel!
    @IBOutlet weak var yourCommentsLabel: UILabel!
    
    //all other reviews stack
    @IBOutlet weak var allReviewsTableView: UITableView!
    
    var recipeList: Array<Recipe> = []
    var selectedRow: Int = 0
    var userList: Array<User> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewControllers = self.navigationController?.viewControllers
        let parent = viewControllers?[0] as! RecipesTableViewController
        
        self.recipeList = parent.recipeList
        self.selectedRow = parent.selectedRow
               
        
        titleLabel.text = self.recipeList[selectedRow].title
        
        //calculate rating
        if (self.recipeList[selectedRow].reviews == []) {
            ratingLabel.text = "-"
        }
        else {
            var totalRating: Int = 0
            var avgRating: Int
            for i in self.recipeList[selectedRow].reviews {
                totalRating += Int(i[1])!
            }
            avgRating = totalRating/self.recipeList[selectedRow].reviews.count
            
            ratingLabel.text = String(avgRating)
        }
        
        //convert image
        thumbnailImage.image = Recipe.Image.getImage(self.recipeList[selectedRow].thumbnail)()
        
        //get username
        DataManager.loadUser() {
            userListFromFirestore in
            self.userList = userListFromFirestore
            for i in self.userList {
                if (i.uid == self.recipeList[self.selectedRow].uid) {
                    self.usernameLabel.text = i.username
                }
            }
        }
        
        descLabel.text = self.recipeList[selectedRow].desc
        ingLabel.text = self.recipeList[selectedRow].ingredients
        instructionLabel.text = self.recipeList[selectedRow].instructions
        
        
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
