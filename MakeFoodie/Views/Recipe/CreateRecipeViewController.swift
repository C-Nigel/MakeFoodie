//
//  CreateRecipeViewController.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 8/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class CreateRecipeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var ingredientTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var selectPictureButton: UIButton!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var titleError: UILabel!
    @IBOutlet weak var descError: UILabel!
    @IBOutlet weak var ingredientError: UILabel!
    @IBOutlet weak var instructionError: UILabel!
    @IBOutlet weak var thumbnailError: UILabel!
    
    var username: String = ""
    
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
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //isfocused doesnt work , if has only isempty it shows all errors when one is empty, jumps to instructions box when typing in desc :"D
        if (self.descTextView.isFocused && self.descTextView.text!.isEmpty) {
            descError.text = "Description required!"
        }
        else {
            descError.text = ""
        }
        
        if (self.ingredientTextView.isFocused && self.ingredientTextView.text!.isEmpty) {
            ingredientError.text = "Ingredients required!"
        }
        else {
            ingredientError.text = ""
        }
        
        if (self.instructionsTextView.isFocused && self.instructionsTextView.text!.isEmpty) {
            instructionError.text = "Instructions required!"
        }
        else {
            instructionError.text = ""
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
    @IBAction func saveButtonPressed(_ sender: Any) {
        if (titleInput.text!.isEmpty) {
            titleError.text = "Title required!"
        }
        else {
            titleError.text = ""
        }
        
        if !(titleInput.text!.isEmpty && descTextView.text!.isEmpty && ingredientTextView.text!.isEmpty && instructionsTextView.text!.isEmpty) {
            /*Recipe(title: self.titleInput.text!, desc: self.descTextView.text!, ingredients: self.ingredientTextView, instructions: self.instructionsTextView.text!, thumbnail: "TEST", username: self.username)*/
        }
        
    }
    @IBAction func titleChanged(_ sender: Any) {
        if (titleInput.text!.isEmpty) {
            titleError.text = "Title required!"
        }
        else {
            titleError.text = ""
        }
    }
    
}
