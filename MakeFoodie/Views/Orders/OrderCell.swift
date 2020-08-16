//
//  OrderCell.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 29/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    @IBOutlet weak var itemimage: UIImageView!
    @IBOutlet weak var itemname: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var orderuidlb: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
