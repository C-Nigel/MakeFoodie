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

class RecipeDetailViewController: UIViewController, UIScrollViewDelegate {

    //labels for recipe

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var heartButton: UIButton!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var ingLabel: UILabel!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    
    //edit and delete buttons
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    //add review button

    @IBOutlet weak var addReviewButton: UIButton!
    
    @IBOutlet weak var editReviewButton: UIButton!
    @IBOutlet weak var deleteReviewButton: UIButton!
    //current user review
    @IBOutlet weak var yourUsernameLabel: UILabel!
    @IBOutlet weak var yourRatingLabel: UILabel!
    @IBOutlet weak var yourCommentsLabel: UILabel!
    
    
    @IBOutlet weak var reviewTitle: UILabel!
    @IBOutlet weak var allReviewsTableView: UITableView!
    
    var recipeList: Array<Recipe> = []
    var selectedRow: Int = 0
    var userList: Array<User> = []
    var curruid: String = ""
    var otherReviews: Dictionary<String, Dictionary<String, String>> = [:]

    @IBOutlet weak var noReviewsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //loading data to view the recipe
        titleLabel.text = self.recipeList[selectedRow].title
        
        //calculate rating
        if (self.recipeList[selectedRow].reviews.isEmpty) {
            ratingLabel.text = "-"
        }
        else {
            var totalRating: Int = 0
            var avgRating: Int
            for i in self.recipeList[selectedRow].reviews.keys {
                totalRating += Int(self.recipeList[selectedRow].reviews[i]!["Rating"]!)!
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
                    self.curruid = i.uid
                }
            }
        }
        
        descLabel.text = self.recipeList[selectedRow].desc
        ingLabel.text = self.recipeList[selectedRow].ingredients
        instructionLabel.text = self.recipeList[selectedRow].instructions
        
        //checkUser
        
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                let uidd: String = user.uid
                DataManager.loadUser() {
                    userListFromFirestore in
                    self.userList = userListFromFirestore
                    for i in self.userList {
                        if (i.uid == uidd) {
                            self.curruid = i.uid
                             
                            //check if recipe uid matches current user
                            if (self.recipeList[self.selectedRow].uid != self.curruid) {
                                //if doesnt match, hide edit and delete button
                                self.editButton.isEnabled = false
                                self.editButton.tintColor = UIColor.clear
                                self.deleteButton.isEnabled = false
                                self.deleteButton.tintColor = UIColor.clear
                                
                            }
                            
                            //check if user has a review for this recipe

                            if !(self.recipeList[self.selectedRow].reviews.isEmpty) { //if reviews not empty
                                for i in self.recipeList[self.selectedRow].reviews.keys { //i = keys in reviews dict
                                    if (self.recipeList[self.selectedRow].reviews[i]!["uid"] == self.curruid) {
                                        //if has current user review, hide add review button and show your review stack
                                        self.addReviewButton.isHidden = true
                                        
                                        //change text of reviewTitle to Other Reviews
                                        self.reviewTitle.text = "Other Reviews"
                                        //pop the record of current user's review, add the updated list to otherReviews
                                        self.recipeList[self.selectedRow].reviews.removeValue(forKey: self.curruid)
                                        self.otherReviews = self.recipeList[self.selectedRow].reviews
                                        //if other reviews is empty
                                        if (self.otherReviews.isEmpty) {
                                            //hide allReviewsTableView and show label no reviews
                                            self.allReviewsTableView.isHidden = true
                                            self.noReviewsLabel.isHidden = false
                                        }
                                        
                                    }
                                    //else, show add review and hide your review stack
                                        //with reviewTitle text being Reviews
                                    else {
                                        self.addReviewButton.isHidden = false
                                        self.reviewTitle.text = "Reviews"
                                    }
                                }
                            }
                            //else (if reviews empty)
                            else {
                                //hide allReviewsTableView and show label no reviews
                                self.noReviewsLabel.isHidden = false
                                
                            }
                            
                        }
                    }
                }
            }
            
        }
        

        
    } //end viewDidLoad
    
    
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
            
            
            //putting data into the labels to view the recipe when view appears (after editing)
            self.titleLabel.text = self.recipeList[self.selectedRow].title
            
            //convert image
            self.thumbnailImage.image = Recipe.Image.getImage(self.recipeList[self.selectedRow].thumbnail)()
        
            
            self.descLabel.text = self.recipeList[self.selectedRow].desc
            self.ingLabel.text = self.recipeList[self.selectedRow].ingredients
            self.instructionLabel.text = self.recipeList[self.selectedRow].instructions
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "addReview") {
            //pass recipeID and curruid into add review vc
        }
        if (segue.identifier == "editReview") {
            
        }
        if (segue.identifier == "editRecipe") {
            let destView = segue.destination as! EditRecipeViewController
            destView.recipeList = self.recipeList
            destView.selectedRow = self.selectedRow
            destView.curruid = self.curruid
            destView.userList = self.userList
        }
    }
    

}
