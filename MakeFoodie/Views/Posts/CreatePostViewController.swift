//
//  CreatePostViewController.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 5/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    // Inputs
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var takePicture: UIButton!
    @IBOutlet weak var selectPicture: UIButton!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    // Error messages
    @IBOutlet weak var titleError: UILabel!
    @IBOutlet weak var priceError: UILabel!
    @IBOutlet weak var thumbnailError: UILabel!
    @IBOutlet weak var descError: UILabel!
    
    // String array for categories
    var categoryPickerData : [String] = [
        "Western",
        "Chinese",
        "Indian",
        "Japanese",
        "Korean",
        "Thai",
        "Halal",
        "Vegetarian",
        "Baked Goods",
        "Snacks",
        "Beverages",
        "Others"
    ]
    
    var postList: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        descTextView.delegate = self
        
        // Close keyboard when click outside textField
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // Set round border for descTextView
        self.descTextView.layer.borderColor = UIColor.black.cgColor
        self.descTextView.layer.borderWidth = 0.3
        self.descTextView.layer.cornerRadius = 6
        
        // If no image in imageView, hide it
        if (self.thumbnailImageView.image == nil)
        {
            self.thumbnailImageView.isHidden = true
        }
        
        // Check if device has a camera
        if !(UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            // Hide if not available
            takePicture.isHidden = true
        }
        
        // Hide error messages
        titleError.isHidden = true
        priceError.isHidden = true
        thumbnailError.isHidden = true
        descError.isHidden = true
        
        loadPosts()
    }
    
    func loadPosts() {
        DataManager.loadPosts ()
        {
            postListFromFirestore in

            // Assign list to list from Firestore
            self.postList = postListFromFirestore
        }
    }
    
    // Picker view columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // How many items in a list to display for a given component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryPickerData.count
    }
    
    // What to display in picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryPickerData[row]
    }
    
    // Resize thumbnail image
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
        self.thumbnailImageView.isHidden = false // Ensure imageView is not hidden after selection
        self.thumbnailImageView!.image = resizedImage
        UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil) // Save the image selected/taken by user

        picker.dismiss(animated: true) // Close picker
        
        if (self.thumbnailImageView.image == nil) {
            thumbnailError.isHidden = false
        }
        else {
            thumbnailError.isHidden = true
        }
    }
    
    // User cancels from taking or selecting image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Check if desc textView is empty (White space + Blank)
        if (descTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty == true) {
            descError.isHidden = false
            descTextView.layer.borderColor = UIColor.red.cgColor
            descTextView.layer.borderWidth = 1.0
            descTextView.layer.cornerRadius = 6
        }
        else {
            descError.isHidden = true
            descTextView.layer.borderColor = UIColor.black.cgColor
            descTextView.layer.borderWidth = 0.3
            descTextView.layer.cornerRadius = 6
        }
    }
    
    // Run when user make changes to the title text field
    @IBAction func titleTextFieldChanged(_ sender: Any) {
        // Check if title textField is empty (White space + Blank)
        if (titleTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true) {
            titleError.isHidden = false
            titleTextField.layer.borderColor = UIColor.red.cgColor
            titleTextField.layer.borderWidth = 1
            titleTextField.layer.cornerRadius = 6
        }
        else {
            titleError.isHidden = true
            titleTextField.layer.borderColor = UIColor.black.cgColor
            titleTextField.layer.borderWidth = 0.3
            titleTextField.layer.cornerRadius = 6
        }
    }
    
    // Run when user make changes to the price text field
    @IBAction func priceTextFieldChanged(_ sender: Any) {
        // Check if price textField is empty (White space + Blank)
        if (priceTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true) {
            priceError.text = "Please enter a price."
            priceError.isHidden = false
            priceTextField.layer.borderColor = UIColor.red.cgColor
            priceTextField.layer.borderWidth = 1.0
            priceTextField.layer.cornerRadius = 6
        }
        else {
            // Check for decimal number
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            if let decimalNo = formatter.number(from: priceTextField.text!) {
                priceError.isHidden = true
                priceTextField.layer.borderColor = UIColor.black.cgColor
                priceTextField.layer.borderWidth = 0.3
                priceTextField.layer.cornerRadius = 6
            }
            else {
                priceError.text = "Please enter a valid number."
                priceError.isHidden = false
                priceTextField.layer.borderColor = UIColor.red.cgColor
                priceTextField.layer.borderWidth = 1.0
                priceTextField.layer.cornerRadius = 6
            }
        }
    }
    
    // Click on Take Picture
    @IBAction func takePicturePressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true // Allows editing of image
        picker.sourceType = .camera // Use camera
        self.present(picker, animated: true)
    }
    
    // Click on Select Picture
    @IBAction func selectPicturePressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true // Allows editing of image
        picker.sourceType = .photoLibrary // Use image from library
        self.present(picker, animated: true)
    }

    
    // Click cancel button
    @IBAction func cancelButtonPressed(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    // Click save button
    @IBAction func saveButtonPressed(_ sender: Any) {
        // Bool var to check valid creation
        var verified = true
        
        // Check again if title,price,desc is empty (White space + Blank) - If user click save after clicking add icon from prev controller
        if (titleTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true) {
            titleError.isHidden = false
            titleTextField.layer.borderColor = UIColor.red.cgColor
            titleTextField.layer.borderWidth = 1.0
            titleTextField.layer.cornerRadius = 6
            verified = false
        }
        else {
            titleError.isHidden = true
            titleTextField.layer.borderColor = UIColor.black.cgColor
            titleTextField.layer.borderWidth = 0.3
            titleTextField.layer.cornerRadius = 6
        }
        
        if (priceTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true) {
            priceError.text = "Please enter a price."
            priceError.isHidden = false
            priceTextField.layer.borderColor = UIColor.red.cgColor
            priceTextField.layer.borderWidth = 1.0
            priceTextField.layer.cornerRadius = 6
            verified = false
        }
        else {
            // Check for decimal number
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            if let decimalNo = formatter.number(from: priceTextField.text!) {
                print(decimalNo)
                priceError.isHidden = true
                priceTextField.layer.borderColor = UIColor.black.cgColor
                priceTextField.layer.borderWidth = 0.3
                priceTextField.layer.cornerRadius = 6
            }
            else {
                priceError.text = "Please input a valid number."
                priceError.isHidden = false
                priceTextField.layer.borderColor = UIColor.red.cgColor
                priceTextField.layer.borderWidth = 1.0
                priceTextField.layer.cornerRadius = 6
                verified = false
            }
        }
        
        if (descTextView.text?.trimmingCharacters(in: .whitespaces).isEmpty == true) {
            descError.isHidden = false
            descTextView.layer.borderColor = UIColor.red.cgColor
            descTextView.layer.borderWidth = 1.0
            descTextView.layer.cornerRadius = 6
            verified = false
        }
        else {
            descError.isHidden = true
            descTextView.layer.borderColor = UIColor.black.cgColor
            descTextView.layer.borderWidth = 0.3
            descTextView.layer.cornerRadius = 6
        }
        
        if (self.thumbnailImageView.image == nil) {
            thumbnailError.isHidden = false
            verified = false
        }
        else {
            thumbnailError.isHidden = true
        }
        
        if (verified == true) {
            // Selected row of picker view
            let row = categoryPickerView.selectedRow(inComponent: 0)
            // Get data selected from picker data
            let selectedCategory = categoryPickerData[row]
            
            var listCount: Int = 0
            
            // Set id to increment every addition
            // If list empty, id starts from 0
            if (postList.isEmpty) {
                listCount = 0
            }
            // else add 1 to total list count
            else {
                listCount = postList.count - 1
            }
            
            let viewControllers = self.navigationController?.viewControllers
            let parent = viewControllers?[0] as! PostsTableViewController
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            
            let post:Post = Post(id: listCount, title: titleTextField.text!, price: formatter.number(from: priceTextField.text!)!.decimalValue, desc: descTextView.text!, thumbnail: Post.Image.init(withImage: thumbnailImageView.image!), category: selectedCategory, userName: parent.username)
            
            DataManager.insertOrEditPost(post)
            parent.loadPosts()
            
            // Redirect back to tableView
            self.navigationController?.popViewController(animated: true)
        }
    }
}
