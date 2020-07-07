//
//  RecipeViewController.swift
//  MakeFoodie
//
//  Created by M06-3 on 7/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var descInput: UITextView!
    @IBOutlet weak var ingredientInput: UITextField!
    @IBOutlet weak var instructionsInput: UITextView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var selectPictureButton: UIButton!
    
    @IBOutlet weak var addIngredientButton: UIButton!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var titleError: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func saveButtonPressed(_ sender: Any) {
        if (titleInput.text!.isEmpty) {
            print("Username required!")
            titleError.text = "Username required!"
        }
        else {
            titleError.text = ""
        }
    }
    
}
