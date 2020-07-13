//
//  CategoriesTableViewController.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 7/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    @IBOutlet var categoriesTableView: UITableView!
    var categories : [String] = [
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
    
    var categoryImages: [String] = [
        "western",
        "chinese",
        "indian",
        "japanese",
        "korean",
        "thai",
        "halal",
        "vegetarian",
        "baked-goods",
        "snacks",
        "beverages",
        "others"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Query table view to see if there are any UITableViewCells that can be reused. iOS will create a new one if there aren't any.
        let cell : CategoryCell = tableView.dequeueReusableCell (withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell

        // Use the reused cell/newly created cell and update it
        let c = categories[indexPath.row]
        cell.categoryLabel.text = c
        cell.categoryLabel.sizeToFit()
        
        let i = categoryImages[indexPath.row]
        cell.categoryImageView.image = UIImage(named: i)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set the category name to the selected table view cell
        if segue.identifier == "ViewCategory"
        {
            let destViewController = segue.destination as! ViewCategoryTableViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            if myIndexPath != nil
            {
                let categoryName = categories[myIndexPath!.row]
                destViewController.viewCategoryTitle = categoryName
            }
        }
    }
}
