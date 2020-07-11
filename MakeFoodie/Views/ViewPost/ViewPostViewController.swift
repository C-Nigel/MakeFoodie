//
//  ViewPostViewController.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 7/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class ViewPostViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // This function is triggered when the view is about to appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        titleLabel.text = post?.title
        postImageView.image = post?.thumbnail.getImage()
        usernameLabel.text = post?.userName
        priceLabel.text = "$\(post!.price)"
        descLabel.text = post?.desc
        categoryLabel.text = post?.category
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowPostDetails")
        {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            let editPostViewController = segue.destination as! EditPostViewController
        }
    }
}
