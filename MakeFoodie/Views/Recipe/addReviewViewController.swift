//
//  addReviewViewController.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 15/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class addReviewViewController: UIViewController {

    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var ratingError: UILabel!
    
    var recipeList: Array<Recipe> = []
    var userList: Array<User> = []
    var curruid: String = ""
    
    var reviews: Dictionary<String, Dictionary<String, String>> = [:]
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentsTextView.layer.borderColor = UIColor.black.cgColor
        commentsTextView.layer.borderWidth = 0.3
        commentsTextView.layer.cornerRadius = 6

        self.reviews = self.recipe!.reviews
        
        //hide keyboard when clicking outside input area
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if (ratingControl.rating != 0) {
            self.reviews.updateValue(["Rating": String(self.ratingControl.rating), "Comments": self.commentsTextView.text], forKey: self.curruid)
            
            let viewControllers = self.navigationController?.viewControllers
            let tableViewController = viewControllers?[0] as! RecipesTableViewController
            let parent = viewControllers?[1] as! RecipeDetailViewController
            
            self.recipeList.append(Recipe(recipeID: self.recipe!.recipeID, title: self.recipe!.title, desc: self.recipe!.desc, ingredients: self.recipe!.ingredients, instructions: self.recipe!.instructions, thumbnail: self.recipe!.thumbnail, reviews:self.reviews, uid: self.recipe!.uid))
            
            //reassign recipe to the new version
            self.recipe = Recipe(recipeID: self.recipe!.recipeID, title: self.recipe!.title, desc: self.recipe!.desc, ingredients: self.recipe!.ingredients, instructions: self.recipe!.instructions, thumbnail: self.recipe!.thumbnail, reviews:self.reviews, uid: self.recipe!.uid)
            
            if (self.recipe != nil) {
                parent.recipe = self.recipe
                DataManager.insertOrReplaceRecipe(self.recipe!)
            }
            
            //loadRecipe
            tableViewController.loadRecipes()
            parent.loadRecipes()
            parent.viewDidLoad()
            
            //going back to RecipeDetailViewController after editing
            self.navigationController?.popViewController(animated: true)
            
        }
        else {
            ratingError.text = "Please choose a rating!"
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
