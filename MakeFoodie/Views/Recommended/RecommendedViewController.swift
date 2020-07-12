//
//  RecommendedViewController.swift
//  MakeFoodie
//
//  Created by NIgel Cheong on 10/6/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class RecommendedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let p = itemList[indexPath.row]
        cell.titleLabel.text = p.title
//        cell.itemImageView.image = UIImage(named: p.imageName)
        cell.itemImageView.image = p.thumbnail.getImage()
        cell.usernameLabel.text = p.uid
        cell.priceLabel.text = "$ \(p.price)"
        cell.descriptionLabel.text = p.desc
        
        return cell
    }
    
    func loadRecommendedItems()
    {
        DataManager.loadRecomendedItems()
        {
            itemListFromFirestore in
            
            // This is a closure
            
            // This block of codes is executed when the async loading from Firestore is complete.
            // What it is to reassigned the new list loaded from Firestore.
            
            self.itemList = itemListFromFirestore
            
            //Once done, call on the Table View to reload all its contents
            
            self.tableView.reloadData()
        }
    }
    
    var itemList : [Item] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //itemList.append(Item(
        //title: "Very good duck rice", price: 5, desc: "Best duck and rice u will ever taste", imageName: "Ah-Seng-Braised-Duck-Rice", userName: "Ah Seng"))
        
        loadRecommendedItems()
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
