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

class RecipeDetailViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {

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
    var reviews: Dictionary<String, Dictionary<String, String>> = [:]
    var otherReviews: Dictionary<String, Dictionary<String, String>> = [:]
    var currUserHasReview: Bool = false
    var otherUserHasReview: Bool = false
    var recipe: Recipe?
    
    var favourite:Bool = false
    var loggedInUserUID = ""

    @IBOutlet weak var noReviewsLabel: UILabel!
    
       override func viewDidLoad() {
        super.viewDidLoad()
        getLoggedInUID()
        checkIfFollowedRecipes()
        
        allReviewsTableView.delegate = self
        allReviewsTableView.dataSource = self
        
        //colors
        self.addReviewButton.tintColor = UIColor.white
        self.addReviewButton.backgroundColor = UIColor.orange
        self.yourReviewEditButton.tintColor = UIColor.orange
        self.yourReviewDeleteButton.tintColor = UIColor.orange
        
        //check if recipe uid matches current user
        if (self.recipeList[self.selectedRow].uid != self.curruid) {
            //if doesnt match, hide edit and delete button
            self.editButton.isEnabled = false
            self.editButton.tintColor = UIColor.clear
            self.deleteButton.isEnabled = false
            self.deleteButton.tintColor = UIColor.clear
            
        }
        
        //loading data to view the recipe
        titleLabel.text = self.recipe!.title
        
        //calculate rating
        if (self.recipe!.reviews.isEmpty) {
            ratingLabel.text = "-"
        }
        else {
            var totalRating: Int = 0
            var avgRating: Int
            for i in self.recipe!.reviews.keys {
                totalRating += Int(self.recipe!.reviews[i]!["Rating"]!)!
            }
            avgRating = totalRating/self.recipe!.reviews.count
            
            ratingLabel.text = String(avgRating)
        }
        
        //convert image
        thumbnailImage.image = Recipe.Image.getImage(self.recipe!.thumbnail)()
        
        //get username
        DataManager.loadUser() {
            userListFromFirestore in
            self.userList = userListFromFirestore
            for i in self.userList {
                if (i.uid == self.recipe!.uid) {
                    self.usernameLabel.text = i.username
                }
            }
        }
        
        descLabel.text = self.recipe!.desc
        ingLabel.text = self.recipe!.ingredients
        instructionLabel.text = self.recipe!.instructions
        if !(self.userList.isEmpty) { //if userList not empty
            
            if (self.recipe!.reviews.isEmpty) { //if reviews is empty
                //hide your review, hide tableview
                self.addReviewButton.isHidden = false
                self.yourUsernameLabel.isHidden = true
                self.yourRatingLabel.isHidden = true
                self.yourCommentsLabel.isHidden = true
                self.yourStar.isHidden = true
                self.yourReviewLabel.isHidden = true
                self.yourReviewEditButton.isHidden = true
                self.yourReviewDeleteButton.isHidden = true
                self.allReviewsTableView.isHidden = true
            }
            else { //if reviews not empty
                if (self.recipe!.reviews.keys.contains(self.curruid)) {
                    currUserHasReview = true
                }
                else {
                    currUserHasReview = false
                }
                
                for i in self.recipe!.reviews.keys { //i = keys in reviews dict
                    if (i != self.curruid) {
                        otherUserHasReview = true
                    }
                }
                if (currUserHasReview) {
                    print("currUserHasReview")
                    //if has current user review, hide add review button and show your review
                    for i in self.recipe!.reviews.keys {
                        if (i == self.curruid) {
                            self.yourReviewEditButton.isHidden = false
                            self.yourReviewDeleteButton.isHidden = false
                            self.addReviewButton.isHidden = true
                            self.yourUsernameLabel.isHidden = false
                            self.yourRatingLabel.isHidden = false
                            self.yourCommentsLabel.isHidden = false
                            self.yourStar.isHidden = false
                            self.yourReviewLabel.isHidden = false
                            //assign values to current user's review
                            self.yourRatingLabel.text = self.recipe!.reviews[i]!["Rating"]
                            
                            if (self.recipe!.reviews[i]!["Comments"] != "") {
                                self.yourCommentsLabel.text = self.recipe!.reviews[i]!["Comments"]
                            }
                            else {
                                self.yourCommentsLabel.isHidden = true
                            }
                            for x in self.userList {
                                if (x.uid == i) {
                                    yourUsernameLabel.text = x.username
                                }
                            }
                            
                        }
                    }
                }
                else {
                    print("curr user no review")
                    //if current user has no review, show add review and hide your review
                    self.addReviewButton.isHidden = false
                    self.yourUsernameLabel.isHidden = true
                    self.yourRatingLabel.isHidden = true
                    self.yourCommentsLabel.isHidden = true
                    self.yourStar.isHidden = true
                    self.yourReviewLabel.isHidden = true
                    self.yourReviewEditButton.isHidden = true
                    self.yourReviewDeleteButton.isHidden = true
                    

                }
                
                if (otherUserHasReview) {
                    self.noReviewsLabel.isHidden = true
                    print("otherUserHasReview")
                    if (currUserHasReview) {
                        print("other & current user has review")
                        //change reviewlabel to Other Reviews, hide addReview btn and show your review
                        self.reviewTitle.text = "Other Reviews"
                        for i in self.recipe!.reviews.keys {
                            if (i == self.curruid) {
                                self.yourReviewEditButton.isHidden = false
                                self.yourReviewDeleteButton.isHidden = false
                                self.addReviewButton.isHidden = true
                                self.yourUsernameLabel.isHidden = false
                                self.yourRatingLabel.isHidden = false
                                self.yourCommentsLabel.isHidden = false
                                self.yourStar.isHidden = false
                                self.yourReviewLabel.isHidden = false
                                //assign values to current user's review
                                self.yourRatingLabel.text = self.recipe!.reviews[i]!["Rating"]
                                
                                if (self.recipe!.reviews[i]!["Comments"] != "") {
                                    self.yourCommentsLabel.text = self.recipe!.reviews[i]!["Comments"]
                                }
                                else {
                                    self.yourCommentsLabel.isHidden = true
                                }
                            }
                            else {
                                self.otherReviews.updateValue(self.recipe!.reviews[i]!, forKey: i)
                            }
                        }
                        //hide no reviews label and show all reviews tableview
                        self.noReviewsLabel.isHidden = true
                        self.allReviewsTableView.isHidden = false
                    }
                    else {
                        print("only other user review")
                        //if only other user has review, assign cell labels, reviewlabel is Reviews
                        reviewTitle.text = "Reviews"
                        //add remaining reviews to otherReviews (not counting current user's)
                        for i in self.recipe!.reviews.keys {
                            if (i != self.curruid) {
                            self.otherReviews.updateValue(self.recipe!.reviews[i]!, forKey: i)
                            }
                        }
                    }
                }
                else { //if other user has no review
                    print("other user no review")
                    //if curr user has review
                    if (currUserHasReview) {
                        //change reviewTitle to Other Reviews
                        reviewTitle.text = "Other Reviews"
                    }
                    //show no reviews label and hide tableview
                    self.noReviewsLabel.isHidden = false
                    self.allReviewsTableView.isHidden = true
                }
                
                
            }
            
        }
        else { //if userList is empty, loadUser again
            DataManager.loadUser() {
                userListFromFirestore in
                self.userList = userListFromFirestore
                for i in self.userList {
                    if (i.uid == self.recipe!.uid) {
                        self.usernameLabel.text = i.username
                    }
                }
                self.viewDidLoad()
            }
        }

        loadRecipes()
        self.allReviewsTableView.reloadData()
    } //end viewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        DataManager.loadRecipes() {
            recipeListFromFirestore in

            // This is a closure.
            //
            // This block of codes is executed when the // async loading from Firestore is complete.
            // What it is to reassigned the new list loaded
            // from Firestore. //
            self.recipeList = recipeListFromFirestore
            
            self.loadData()
                       
            self.allReviewsTableView.reloadData()
        }
    }
        
    func loadData() {
        if (self.recipe != nil) {
            print("LOADDATA")
            print(self.recipe!.reviews)
            //loading data to view the recipe
            titleLabel.text = self.recipe!.title
            
            //calculate rating
            if (self.recipe!.reviews.isEmpty) {
                ratingLabel.text = "-"
            }
            else {
                var totalRating: Int = 0
                var avgRating: Int
                for i in self.recipe!.reviews.keys {
                    totalRating += Int(self.recipe!.reviews[i]!["Rating"]!)!
                }
                avgRating = totalRating/self.recipe!.reviews.count
                
                ratingLabel.text = String(avgRating)
            }
            
            //convert image
            thumbnailImage.image = Recipe.Image.getImage(self.recipe!.thumbnail)()
            
            //get username
            DataManager.loadUser() {
                userListFromFirestore in
                self.userList = userListFromFirestore
                for i in self.userList {
                    if (i.uid == self.recipe!.uid) {
                        self.usernameLabel.text = i.username
                    }
                }
            }
            
            descLabel.text = self.recipe!.desc
            ingLabel.text = self.recipe!.ingredients
            instructionLabel.text = self.recipe!.instructions
            if !(self.userList.isEmpty) { //if userList not empty
                
                if (self.recipe!.reviews.isEmpty) { //if reviews is empty
                    //hide your review, hide tableview
                    self.addReviewButton.isHidden = false
                    self.yourUsernameLabel.isHidden = true
                    self.yourRatingLabel.isHidden = true
                    self.yourCommentsLabel.isHidden = true
                    self.yourStar.isHidden = true
                    self.yourReviewLabel.isHidden = true
                    self.yourReviewEditButton.isHidden = true
                    self.yourReviewDeleteButton.isHidden = true
                    self.allReviewsTableView.isHidden = true
                }
                else { //if reviews not empty
                    if (self.recipe!.reviews.keys.contains(self.curruid)) {
                        currUserHasReview = true
                    }
                    else {
                        currUserHasReview = false
                    }
                    
                    for i in self.recipe!.reviews.keys { //i = keys in reviews dict
                        if (i != self.curruid) {
                            otherUserHasReview = true
                        }
                    }
                    if (currUserHasReview) {
                        print("currUserHasReview")
                        //if has current user review, hide add review button and show your review
                        for i in self.recipe!.reviews.keys {
                            if (i == self.curruid) {
                                self.yourReviewEditButton.isHidden = false
                                self.yourReviewDeleteButton.isHidden = false
                                self.addReviewButton.isHidden = true
                                self.yourUsernameLabel.isHidden = false
                                self.yourRatingLabel.isHidden = false
                                self.yourCommentsLabel.isHidden = false
                                self.yourStar.isHidden = false
                                self.yourReviewLabel.isHidden = false
                                //assign values to current user's review
                                self.yourRatingLabel.text = self.recipe!.reviews[i]!["Rating"]
                                
                                if (self.recipe!.reviews[i]!["Comments"] != "") {
                                    self.yourCommentsLabel.text = self.recipe!.reviews[i]!["Comments"]
                                }
                                else {
                                    self.yourCommentsLabel.isHidden = true
                                }
                                for x in self.userList {
                                    if (x.uid == i) {
                                        yourUsernameLabel.text = x.username
                                    }
                                }
                                
                            }
                        }
                    }
                    else {
                        print("curr user no review")
                        //if current user has no review, show add review and hide your review
                        self.addReviewButton.isHidden = false
                        self.yourUsernameLabel.isHidden = true
                        self.yourRatingLabel.isHidden = true
                        self.yourCommentsLabel.isHidden = true
                        self.yourStar.isHidden = true
                        self.yourReviewLabel.isHidden = true
                        self.yourReviewEditButton.isHidden = true
                        self.yourReviewDeleteButton.isHidden = true
                        

                    }
                    
                    if (otherUserHasReview) {
                        self.noReviewsLabel.isHidden = true
                        print("otherUserHasReview")
                        if (currUserHasReview) {
                            print("other & current user has review")
                            //change reviewlabel to Other Reviews, hide addReview btn and show your review
                            self.reviewTitle.text = "Other Reviews"
                            for i in self.recipe!.reviews.keys {
                                if (i == self.curruid) {
                                    self.yourReviewEditButton.isHidden = false
                                    self.yourReviewDeleteButton.isHidden = false
                                    self.addReviewButton.isHidden = true
                                    self.yourUsernameLabel.isHidden = false
                                    self.yourRatingLabel.isHidden = false
                                    self.yourCommentsLabel.isHidden = false
                                    self.yourStar.isHidden = false
                                    self.yourReviewLabel.isHidden = false
                                    //assign values to current user's review
                                    self.yourRatingLabel.text = self.recipe!.reviews[i]!["Rating"]
                                    
                                    if (self.recipe!.reviews[i]!["Comments"] != "") {
                                        self.yourCommentsLabel.text = self.recipe!.reviews[i]!["Comments"]
                                    }
                                    else {
                                        self.yourCommentsLabel.isHidden = true
                                    }
                                }
                                else {
                                    self.otherReviews.updateValue(self.recipe!.reviews[i]!, forKey: i)
                                }
                            }
                            //hide no reviews label and show all reviews tableview
                            self.noReviewsLabel.isHidden = true
                            self.allReviewsTableView.isHidden = false
                        }
                        else {
                            print("only other user review")
                            //if only other user has review, assign cell labels, reviewlabel is Reviews
                            reviewTitle.text = "Reviews"
                            //add remaining reviews to otherReviews (not counting current user's)
                            for i in self.recipe!.reviews.keys {
                                if (i != self.curruid) {
                                self.otherReviews.updateValue(self.recipe!.reviews[i]!, forKey: i)
                                }
                            }
                        }
                    }
                    else { //if other user has no review
                        print("other user no review")
                        //if curr user has review
                        if (currUserHasReview) {
                            //change reviewTitle to Other Reviews
                            reviewTitle.text = "Other Reviews"
                        }
                        //show no reviews label and hide tableview
                        self.noReviewsLabel.isHidden = false
                        self.allReviewsTableView.isHidden = true
                    }
                    
                    
                }
                
            }
            else { //if userList is empty, loadUser again
                DataManager.loadUser() {
                    userListFromFirestore in
                    self.userList = userListFromFirestore
                    for i in self.userList {
                        if (i.uid == self.recipe!.uid) {
                            self.usernameLabel.text = i.username
                        }
                    }
                }
            }
        }
        
    } // end loadData
    
    
    
    // when heart Button is pressed
    @IBAction func heartButtonPressed(_ sender: UIButton) {
        
        if favourite == false
        {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favourite = true
            DataManager.insertRecipeAndPosttFollowData(followeruid: loggedInUserUID, following: self.recipe!.recipeID, type: "recipes")
            
        }
        else
        {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favourite = false
            DataManager.deleteRecipeAndPosttFollowData(followeruid: loggedInUserUID, following: self.recipe!.recipeID, type: "recipes")
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

        DataManager.retrieveRecipeAndPosttFollowData(followeruid: loggedInUserUID, following: self.recipe!.recipeID, type: "recipes") { (result) in
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
            self.loadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.otherReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewItem", for: indexPath) as! AllReviewsTableViewCell

        let r = self.otherReviews
        for i in self.userList {
            if (r[i.uid] != nil) {
                cell.usernameLabel.text = i.username
                cell.ratingLabel.text = r[i.uid]!["Rating"]
                cell.commentsLabel.text = r[i.uid]!["Comments"]
            }
            /*for x in r.keys {
                print(x, "//", i.uid)
                if (i.uid == x) {
                    cell.usernameLabel.text = i.username
                    cell.ratingLabel.text = r[x]!["Rating"]
                    cell.commentsLabel.text = r[x]!["Comments"]
                    print(i.username, r[x]!["Rating"])
                    print(i.username, r[x]!["Comments"])
                }
            }*/
        }

        
        return cell
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        // Alert controller
        let alertController = UIAlertController(title: "Delete Recipe", message: "Are you sure you want to delete this recipe?", preferredStyle: .alert)
               
        // Confirm action
        let confirm = UIAlertAction(title: "Delete", style: .destructive) {
            (action:UIAlertAction!) in
            
            // Delete recipe
            DataManager.deleteRecipe(self.recipeList[self.selectedRow])
            
            // Delete followers
            DataManager.deleteAllfollowers(id: self.recipeList[self.selectedRow].recipeID, type: "recipe")
            
            let viewControllers = self.navigationController?.viewControllers
            let parent = viewControllers?[0] as! RecipesTableViewController
            
            //loadRecipes
            parent.loadRecipes()
            
            //since recipe is deleted, reset selectedRow
            self.selectedRow = 0
            
            //go to tableview
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(confirm)
               
        // Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
            (action:UIAlertAction!) in
            
            print("Delete recipe cancelled");
        }
        alertController.addAction(cancel)
               
        // Present alertController
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    @IBAction func yourReviewDeleteButtonPressed(_ sender: Any) {
        // Alert controller
        let alertController = UIAlertController(title: "Delete Review", message: "Are you sure you want to delete this review?", preferredStyle: .alert)
               
        // Confirm action
        let confirm = UIAlertAction(title: "Delete", style: .destructive) {
            (action:UIAlertAction!) in
            
            //remove review from reviews
            for i in self.recipeList[self.selectedRow].reviews.keys {
                if (i != self.curruid) {
                    self.reviews.updateValue(self.recipeList[self.selectedRow].reviews[i]!, forKey: i)
                }
            }
                       
            let viewControllers = self.navigationController?.viewControllers
            let parent = viewControllers?[0] as! RecipesTableViewController
            
            if !(self.reviews.isEmpty) {
                self.recipe = Recipe(recipeID: self.recipeList[self.selectedRow].recipeID, title: self.recipeList[self.selectedRow].title, desc: self.recipeList[self.selectedRow].desc, ingredients: self.recipeList[self.selectedRow].ingredients, instructions: self.recipeList[self.selectedRow].instructions, thumbnail: self.recipeList[self.selectedRow].thumbnail, reviews: self.reviews, uid: self.recipeList[self.selectedRow].uid)
                
                if (self.recipe != nil) {
                    //save the updated recipe
                    DataManager.insertOrReplaceRecipe(self.recipe!)
                }
                
            }
                
            //loadRecipes
            parent.loadRecipes()
            self.loadRecipes()
            self.loadData()
               

        }
        alertController.addAction(confirm)
               
        // Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
            (action:UIAlertAction!) in
            
            print("Delete review cancelled");
        }
        alertController.addAction(cancel)
               
        // Present alertController
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "addReview") {
            //pass recipe and curruid into add review vc
            let destView = segue.destination as! addReviewViewController
            destView.recipeList = self.recipeList
            destView.selectedRow = self.selectedRow
            destView.curruid = self.curruid
            destView.userList = self.userList
            destView.recipe = self.recipe
        }
        if (segue.identifier == "editReview") {
            let destView = segue.destination as! editReviewViewController
            destView.recipeList = self.recipeList
            destView.selectedRow = self.selectedRow
            destView.curruid = self.curruid
            destView.userList = self.userList
            destView.recipe = self.recipe
            
        }
        if (segue.identifier == "editRecipe") {
            let destView = segue.destination as! EditRecipeViewController
            destView.recipeList = self.recipeList
            destView.selectedRow = self.selectedRow
            destView.curruid = self.curruid
            destView.userList = self.userList
            destView.recipe = self.recipe
        }
    }
    

}
