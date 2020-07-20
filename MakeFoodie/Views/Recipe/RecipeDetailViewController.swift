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
    @IBOutlet weak var yourStar: UIImageView!
    @IBOutlet weak var yourReviewLabel: UILabel!
    @IBOutlet weak var yourReviewEditButton: UIButton!
    @IBOutlet weak var yourReviewDeleteButton: UIButton!
    
    
    @IBOutlet weak var reviewTitle: UILabel!
    @IBOutlet weak var allReviewsTableView: UITableView!
    
    var recipeList: Array<Recipe> = []
    var selectedRow: Int = 0
    var userList: Array<User> = []
    var curruid: String = ""
    var otherReviews: Dictionary<String, Dictionary<String, String>> = [:]
    var favourite:Bool = false
    var loggedInUserUID = ""

    @IBOutlet weak var noReviewsLabel: UILabel!
    
       override func viewDidLoad() {
        super.viewDidLoad()
        getLoggedInUID()
        checkIfFollowedRecipes()
        
        //colors
        self.addReviewButton.tintColor = UIColor.white
        self.addReviewButton.backgroundColor = UIColor.orange
        self.editReviewButton.tintColor = UIColor.orange
        self.deleteReviewButton.tintColor = UIColor.orange
        
        
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
        
        //check if recipe uid matches current user
        if (self.recipeList[self.selectedRow].uid != self.curruid) {
            //if doesnt match, hide edit and delete button
            self.editButton.isEnabled = false
            self.editButton.tintColor = UIColor.clear
            self.deleteButton.isEnabled = false
            self.deleteButton.tintColor = UIColor.clear
            
        }
        


        if !(self.recipeList[self.selectedRow].reviews.isEmpty) { //if reviews not empty
            for i in self.recipeList[self.selectedRow].reviews.keys { //i = keys in reviews dict
                if (self.recipeList[self.selectedRow].reviews[i]!["uid"] == self.curruid) {
                    //if has current user review, hide add review button and show your review
                    self.addReviewButton.isHidden = true
                    self.yourUsernameLabel.isHidden = false
                    self.yourRatingLabel.isHidden = false
                    self.yourCommentsLabel.isHidden = false
                    self.yourStar.isHidden = false
                    self.yourReviewLabel.isHidden = false
                    
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
                //if current user has no review, show add review and hide your review
                    //with reviewTitle text being Reviews
                else {
                    self.addReviewButton.isHidden = false
                    self.reviewTitle.text = "Reviews"
                    self.yourUsernameLabel.isHidden = true
                    self.yourRatingLabel.isHidden = true
                    self.yourCommentsLabel.isHidden = true
                    self.yourStar.isHidden = true
                    self.yourReviewLabel.isHidden = true
                    self.yourReviewEditButton.isHidden = true
                    self.yourReviewDeleteButton.isHidden = true

                }
            }
        }
        //else (if reviews empty)
        else {
            //hide allReviewsTableView and show label no reviews
            //hide your review
            self.allReviewsTableView.isHidden = true
            self.noReviewsLabel.isHidden = false
            self.yourUsernameLabel.isHidden = true
            self.yourRatingLabel.isHidden = true
            self.yourCommentsLabel.isHidden = true
            self.yourStar.isHidden = true
            self.yourReviewLabel.isHidden = true
            self.yourReviewEditButton.isHidden = true
            self.yourReviewDeleteButton.isHidden = true
        }
    
        

        
    } //end viewDidLoad
    
    // when heart Button is pressed
    @IBAction func heartButtonPressed(_ sender: UIButton) {
        
        if favourite == false
        {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favourite = true
            DataManager.insertRecipeAndPosttFollowData(followeruid: loggedInUserUID, following: self.recipeList[selectedRow].recipeID, type: "recipes")
            
        }
        else
        {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favourite = false
            DataManager.deleteRecipeAndPosttFollowData(followeruid: loggedInUserUID, following: self.recipeList[selectedRow].recipeID, type: "recipes")
        }
    }
    
    // get uid of curent logged in user
    func getLoggedInUID() {
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                loggedInUserUID = user.uid
            }
        }
    }
    
    // check if the logged in user has a existing record that follows the opened recipe post
    func checkIfFollowedRecipes() {

        DataManager.retrieveRecipeAndPosttFollowData(followeruid: loggedInUserUID, following: self.recipeList[selectedRow].recipeID, type: "recipes") { (result) in
            let documentFound: Bool = result
            
            if documentFound
            {
                // if record found, change button image to fill heart
                self.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.favourite = true
            }
            else
            {
                // just in case
                // if record not found, change button image to hollow heart
                self.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
                self.favourite = false
            }
        }
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
