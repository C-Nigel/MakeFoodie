//
//  EditPostViewController.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 7/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class EditPostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    // Inputs
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    // Image buttons
    @IBOutlet weak var takePicture: UIButton!
    @IBOutlet weak var selectPicture: UIButton!
    
    // Errors
    @IBOutlet weak var titleError: UILabel!
    @IBOutlet weak var priceError: UILabel!
    @IBOutlet weak var thumbnailError: UILabel!
    @IBOutlet weak var descError: UILabel!
    
    // Category data
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
    
    var post: Post?
    var postList: [Post] = []
    var currPostId: Int?
    var currPostUid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set color to buttons
        takePicture.tintColor = UIColor.orange
        selectPicture.tintColor = UIColor.orange
        
        // Set round border for descTextView
        self.descTextView.layer.borderColor = UIColor.black.cgColor
        self.descTextView.layer.borderWidth = 0.3
        self.descTextView.layer.cornerRadius = 6
        
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
    
    // Function that loads data from Firestore and refreshes tableView
    func loadPosts() {
        DataManager.loadPosts ()
        {
            postListFromFirestore in

            // Assign list to list from Firestore
            self.postList = postListFromFirestore
        }
    }
    
    // This function is triggered when the view is about to appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        currPostId = post?.id // Get current post id to know which post to edit
        currPostUid = post?.uid // Get curret post uid
        titleTextField.text = post?.title
        if post?.price != nil {
            priceTextField.text = String(post!.price)
        }
        else {
            priceTextField.text = ""
        }
        thumbnailImageView.image = post?.thumbnail.getImage()
        descTextView.text = post?.desc
        if let selectedCategory = categoryPickerData.firstIndex(of: post!.category) {
            categoryPickerView.selectRow(selectedCategory, inComponent: 0, animated: false)
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
    
    // MARK: - Image
    
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
    
    // MARK: - TextView + TextField Change
    
    // Run if changes made to descTextView
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
            // Check for double
            if Double(priceTextField.text!) != nil {
                // Check if textField has decimal
                if (priceTextField.text!.contains(".")) {
                    // If there is decimal place, and after another decimal, show error
                    if (priceTextField.text!.components(separatedBy: ".")[1].contains(".")) {
                        priceError.text = "Please input a valid number."
                        priceError.isHidden = false
                        priceTextField.layer.borderColor = UIColor.red.cgColor
                        priceTextField.layer.borderWidth = 1.0
                        priceTextField.layer.cornerRadius = 6
                    }
                    else {
                        // Else ensure that only 2dp max
                        switch priceTextField.text!.components(separatedBy: ".")[1].count {
                            case 1, 2: // If 1 or 2dp, accept
                                priceError.isHidden = true
                                priceTextField.layer.borderColor = UIColor.black.cgColor
                                priceTextField.layer.borderWidth = 0.3
                                priceTextField.layer.cornerRadius = 6
                            default:  // If 0 or more than 2dp, reject
                                priceError.text = "Maximum of 2 decimal places."
                                priceError.isHidden = false
                                priceTextField.layer.borderColor = UIColor.red.cgColor
                                priceTextField.layer.borderWidth = 1.0
                                priceTextField.layer.cornerRadius = 6
                        }
                    }
                }
                else {
                    priceError.isHidden = true
                    priceTextField.layer.borderColor = UIColor.black.cgColor
                    priceTextField.layer.borderWidth = 0.3
                    priceTextField.layer.cornerRadius = 6
                }
            }
            else {
                priceError.text = "Please input a valid number."
                priceError.isHidden = false
                priceTextField.layer.borderColor = UIColor.red.cgColor
                priceTextField.layer.borderWidth = 1.0
                priceTextField.layer.cornerRadius = 6
            }
        }
    }
    
    // MARK: - Button actions
    
    // Click on take picture
    @IBAction func takePicturePressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true // Allows editing of image
        picker.sourceType = .camera // Use camera
        self.present(picker, animated: true)
    }
    
    // Click on select picture
    @IBAction func selectPicturePressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true // Allows editing of image
        picker.sourceType = .photoLibrary // Use image from library
        self.present(picker, animated: true)
    }
    
    // Click on cancel button
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
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
            // Check for double
            if Double(priceTextField.text!) != nil {
                // Check if textField has decimal
                if (priceTextField.text!.contains(".")) {
                    // If there is decimal place, and after another decimal, show error
                    if (priceTextField.text!.components(separatedBy: ".")[1].contains(".")) {
                        priceError.text = "Please input a valid number."
                        priceError.isHidden = false
                        priceTextField.layer.borderColor = UIColor.red.cgColor
                        priceTextField.layer.borderWidth = 1.0
                        priceTextField.layer.cornerRadius = 6
                        verified = false
                    }
                    else {
                        // Else ensure that only 2dp max
                        switch priceTextField.text!.components(separatedBy: ".")[1].count {
                            case 1, 2: // If 1 or 2dp, accept
                                priceError.isHidden = true
                                priceTextField.layer.borderColor = UIColor.black.cgColor
                                priceTextField.layer.borderWidth = 0.3
                                priceTextField.layer.cornerRadius = 6
                            default:  // If 0 or more than 2dp, reject
                                priceError.text = "Maximum of 2 decimal places."
                                priceError.isHidden = false
                                priceTextField.layer.borderColor = UIColor.red.cgColor
                                priceTextField.layer.borderWidth = 1.0
                                priceTextField.layer.cornerRadius = 6
                                verified = false
                        }
                    }
                }
                else {
                    priceError.isHidden = true
                    priceTextField.layer.borderColor = UIColor.black.cgColor
                    priceTextField.layer.borderWidth = 0.3
                    priceTextField.layer.cornerRadius = 6
                }
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
            
            let viewControllers = self.navigationController?.viewControllers
            let postsTableView = viewControllers?[0] as! PostsTableViewController
            let parent = viewControllers?[1] as! ViewPostViewController
            let priceValue = Double(priceTextField.text!)
            
            let post:Post = Post(id: currPostId!, title: titleTextField.text!, price: priceValue!, desc: descTextView.text!, thumbnail: Post.Image.init(withImage: thumbnailImageView.image!), category: selectedCategory, uid: currPostUid!)
            
            DataManager.insertOrEditPost(post)
            postsTableView.loadPosts()
            parent.loadPosts()
            
            // Redirect back to tableView
            self.navigationController?.popViewController(animated: true)
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
