//
//  RecipeViewController.swift
//  MakeFoodie
//
//  Created by M06-3 on 7/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var descInput: UITextView!
    @IBOutlet weak var ingredientInput: UITextView!
    @IBOutlet weak var instructionsInput: UITextView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var selectPictureButton: UIButton!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var titleError: UILabel!
    @IBOutlet weak var descError: UILabel!
    
    var username: String = ""
    var ingredientsList: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //set round border for desc and instructions
    self.descInput.layer.borderColor = UIColor.black.cgColor
    self.descInput.layer.borderWidth = 0.3
    self.descInput.layer.cornerRadius = 6
    self.instructionsInput.layer.borderColor = UIColor.black.cgColor
    self.instructionsInput.layer.borderWidth = 0.3
    self.instructionsInput.layer.cornerRadius = 6
    
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
    
        descInput.delegate = self
        ingredientInput.delegate = self
        instructionsInput.delegate = self
        
        /*func textViewDidChange(_ descInput: UITextView) {
            if (self.descInput.text!.isEmpty) {
                descError.text = "Please enter a description."
            }
            else {
                descError.text = ""
            }
        }*/
        
    }
    
    func textViewDidChange(_ descInput: UITextView) {
        if (self.descInput.text!.isEmpty) {
            descError.text = "Description required!"
        }
        else {
            descError.text = ""
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
        
        if !(titleInput.text!.isEmpty && descInput.text!.isEmpty && ingredientInput.text!.isEmpty && instructionsInput.text!.isEmpty) {
            /*Recipe(title: self.titleInput.text!, desc: self.descInput.text!, ingredients: self.ingredientsList, instructions: self.instructionsInput.text!, thumbnail: "TEST", username: self.username)*/
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
