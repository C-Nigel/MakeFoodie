//
//  CreateRecipeViewController.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 8/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class CreateRecipeViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //inputs
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var ingredientTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    //buttons
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var selectPictureButton: UIButton!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //error messages
    @IBOutlet weak var titleError: UILabel!
    @IBOutlet weak var descError: UILabel!
    @IBOutlet weak var ingredientError: UILabel!
    @IBOutlet weak var instructionError: UILabel!
    @IBOutlet weak var thumbnailError: UILabel!
    
    var username: String = ""
    var recipeList: Array<Recipe> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //set round border for desc and instructions
        self.descTextView.layer.borderColor = UIColor.black.cgColor
        self.descTextView.layer.borderWidth = 0.3
        self.descTextView.layer.cornerRadius = 6
            
        self.ingredientTextView.layer.borderColor = UIColor.black.cgColor
        self.ingredientTextView.layer.borderWidth = 0.3
        self.ingredientTextView.layer.cornerRadius = 6
       
        self.instructionsTextView.layer.borderColor = UIColor.black.cgColor
        self.instructionsTextView.layer.borderWidth = 0.3
        self.instructionsTextView.layer.cornerRadius = 6
    
        // If no image in imageView, hide it
        if (self.thumbnailImage.image == nil)
        {
            self.thumbnailImage.isHidden = true
        }
        
        // Check if device has a camera
        if !(UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            // Hide if not available
            takePictureButton.isHidden = true
        }
    
        descTextView.delegate = self
        ingredientTextView.delegate = self
        instructionsTextView.delegate = self
        
        loadRecipes()
        
    }
    
    //load recipes
    func loadRecipes() {
        DataManager.loadRecipes() {
            recipeListFromFirestore in
                self.recipeList = recipeListFromFirestore
        }
        print("RECIPE LIST", self.recipeList)
    }
    
    //when user leaves title blank or whitespace after clicking in
    @IBAction func titleInputChanged(_ sender: Any) {
        if (titleInput.text?.trimmingCharacters(in: .whitespaces).isEmpty == true) {
            titleError.text = "Title required!"
            titleInput.layer.borderColor = UIColor.red.cgColor
            titleInput.layer.borderWidth = 1
            titleInput.layer.cornerRadius = 6
        }
        else {
            titleError.text = ""
            titleInput.layer.borderColor = UIColor.black.cgColor
            titleInput.layer.borderWidth = 0.3
            titleInput.layer.cornerRadius = 6
        }
    }
        
    //textview edited
    func textViewDidChange(_ textView: UITextView) {
        //isfocused doesnt work , if has only isempty it shows all errors when one is empty, jumps to instructions box when typing in desc :"D
        if (textView == descTextView) {
            if (descTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty == true) {
                descError.text = "Description required!"
                descTextView.layer.borderColor = UIColor.red.cgColor
                descTextView.layer.borderWidth = 1
                descTextView.layer.cornerRadius = 6
            }
            else {
                descError.text = ""
                descTextView.layer.borderColor = UIColor.black.cgColor
                descTextView.layer.borderWidth = 0.3
                descTextView.layer.cornerRadius = 6
            }
        }
        
        if (textView == ingredientTextView) {
            if (ingredientTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty == true) {
                ingredientError.text = "Ingredients required!"
                ingredientTextView.layer.borderColor = UIColor.red.cgColor
                ingredientTextView.layer.borderWidth = 1
                ingredientTextView.layer.cornerRadius = 6
                
            }
            else {
                ingredientError.text = ""
                ingredientTextView.layer.borderColor = UIColor.black.cgColor
                ingredientTextView.layer.borderWidth = 0.3
                ingredientTextView.layer.cornerRadius = 6
                
            }
        }
        
        if (textView == instructionsTextView) {
            if (instructionsTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty == true) {
                instructionError.text = "Instructions required!"
                instructionsTextView.layer.borderColor = UIColor.red.cgColor
                instructionsTextView.layer.borderWidth = 1
                instructionsTextView.layer.cornerRadius = 6
            }
            else {
                instructionError.text = ""
                instructionsTextView.layer.borderColor = UIColor.black.cgColor
                instructionsTextView.layer.borderWidth = 0.3
                instructionsTextView.layer.cornerRadius = 6
                
            }
        }
    }
    
    // Called after selecting or taking picture and place into the imageView then closing the picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage : UIImage = info[.editedImage] as! UIImage
        self.thumbnailImage.isHidden = false // Ensure imageView is not hidden after selection
        self.thumbnailImage!.image = chosenImage
        UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil) // Save the image selected/taken by user

        picker.dismiss(animated: true) // Close picker
    }
    
    //when user cancel image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    //when user click take pic
    @IBAction func takePictureButtonPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true // Allows editing of image
        picker.sourceType = .camera // Use camera
        self.present(picker, animated: true)
    }
    
    //when user click select pic
    @IBAction func selectPictureButtonPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true // Allows editing of image
        picker.sourceType = .photoLibrary // Use image from library
        self.present(picker, animated: true)
    }

    //when user click cancel button
    @IBAction func cancelButtonPressed(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    //when user click save button
    @IBAction func saveButtonPressed(_ sender: Any) {
        //variable to check if inputs are valid
        var valid = true
        
        //checking inputs for errors
        if (titleInput.text?.trimmingCharacters(in: .whitespaces).isEmpty == true) {
            titleError.text = "Title required!"
            titleInput.layer.borderColor = UIColor.red.cgColor
            titleInput.layer.borderWidth = 1
            titleInput.layer.cornerRadius = 6
            valid = false
        }
        else {
            titleError.text = ""
            titleInput.layer.borderColor = UIColor.black.cgColor
            titleInput.layer.borderWidth = 0.3
            titleInput.layer.cornerRadius = 6
        }
        if (descTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty == true) {
            descError.text = "Description required!"
            descTextView.layer.borderColor = UIColor.red.cgColor
            descTextView.layer.borderWidth = 1
            descTextView.layer.cornerRadius = 6
            valid = false
                }
        else {
            descError.text = ""
            descTextView.layer.borderColor = UIColor.black.cgColor
            descTextView.layer.borderWidth = 0.3
            descTextView.layer.cornerRadius = 6
            
        }

        if (ingredientTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty == true) {
            ingredientError.text = "Ingredients required!"
            ingredientTextView.layer.borderColor = UIColor.red.cgColor
            ingredientTextView.layer.borderWidth = 1
            ingredientTextView.layer.cornerRadius = 6
            valid = false
                }
        else {
            ingredientError.text = ""
            ingredientTextView.layer.borderColor = UIColor.black.cgColor
            ingredientTextView.layer.borderWidth = 0.3
            ingredientTextView.layer.cornerRadius = 6
            
        }

        if (instructionsTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty == true) {
            instructionError.text = "Instructions required!"
            instructionsTextView.layer.borderColor = UIColor.red.cgColor
            instructionsTextView.layer.borderWidth = 1
            instructionsTextView.layer.cornerRadius = 6
            valid = false
        }
        else {
            instructionError.text = ""
            instructionsTextView.layer.borderColor = UIColor.black.cgColor
            instructionsTextView.layer.borderWidth = 0.3
            instructionsTextView.layer.cornerRadius = 6
            
        }

        if (self.thumbnailImage.image == nil) {
            thumbnailError.text = "Thumbnail required!"
            valid = false
        }
        else {
            thumbnailError.isHidden = true
        }

        
        //if all inputs are filled
        if (valid == true) {
            //init id
            var rID: Int
            
            //if list is empty, id of new recipe is 0
            if (recipeList.isEmpty) {
                rID = 0
            }
            else {
                rID = recipeList.count
            }
            
            recipeList.append(Recipe(recipeID: rID,title: self.titleInput.text!, desc: self.descTextView.text!, ingredients: self.ingredientTextView.text!, instructions: self.instructionsTextView.text!, thumbnail: Recipe.Image.init(withImage: thumbnailImage.image!), reviews: [], username: "zoeey"))
            for i in recipeList {
                print (i.title)
                print(i.desc)
                print(i.ingredients)
                print(i.instructions)
                print(i.thumbnail)
                print(i.reviews)
                print(i.username)
                
                DataManager.insertOrReplaceRecipe(i)
                loadRecipes()
            }
        }
        
    }
    
}
