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
    
    @IBOutlet weak var recipeScrollView: UIScrollView!
    
    var username: String = ""
    var recipeList: Array<Recipe> = []
    let db = Firestore.firestore()
    
    var reviews: Dictionary<String, Dictionary<String, String>> = [:]
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //colors
        self.takePictureButton.tintColor = UIColor.orange
        self.selectPictureButton.tintColor = UIColor.orange
        
        
        
        
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
        
        //hide keyboard when clicking outside input area
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        //for scroll when editing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    } //end viewDidLoad
    
    
    //for scroll when editing
    @objc func keyboardWillShow(notification:NSNotification){

        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.recipeScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        recipeScrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        recipeScrollView.contentInset = contentInset
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
        }
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
    
    //resize image
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
    // Called after selecting or taking picture and place into the imageView then closing the picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage : UIImage = info[.editedImage] as! UIImage
        var resizedImage: UIImage
        
        resizedImage = resizeImage(image: chosenImage, newWidth: 374)
        self.thumbnailImage.isHidden = false // Ensure imageView is not hidden after selection
        self.thumbnailImage!.image = resizedImage
        UIImageWriteToSavedPhotosAlbum(resizedImage, nil, nil, nil) // Save the image selected/taken by user

        picker.dismiss(animated: true) // Close picker
        
        if (self.thumbnailImage.image == nil) {
            thumbnailError.text = "Thumbnail required!"
        }
        else {
            thumbnailError.text = ""
        }
        
    }
    
    //when user cancel image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        
        if (self.thumbnailImage.image == nil) {
            thumbnailError.text = "Thumbnail required!"
        }
        else {
            thumbnailError.text = ""
        }
        
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
            thumbnailError.text = ""
        }

        
        //if all inputs are filled
        if (valid == true) {
            let viewControllers = self.navigationController?.viewControllers
            let parent = viewControllers?[0] as! RecipesTableViewController
            
            let ref = db.collection("recipes")
            let docId = ref.document().documentID
            
            recipeList.append(Recipe(recipeID: docId,title: self.titleInput.text!, desc: self.descTextView.text!, ingredients: self.ingredientTextView.text!, instructions: self.instructionsTextView.text!, thumbnail: Recipe.Image.init(withImage: thumbnailImage.image!), reviews:self.reviews, uid: parent.curruid))
            
            self.recipe = Recipe(recipeID: docId,title: self.titleInput.text!, desc: self.descTextView.text!, ingredients: self.ingredientTextView.text!, instructions: self.instructionsTextView.text!, thumbnail: Recipe.Image.init(withImage: thumbnailImage.image!), reviews:self.reviews, uid: parent.curruid)
            
            if (self.recipe != nil) {
                DataManager.insertOrReplaceRecipe(self.recipe!)
            }
            
            parent.loadRecipes()
            
            //going back to tableviewcontroller after adding
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
}
