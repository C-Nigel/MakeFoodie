//
//  AllReviewsTableViewCell.swift
//  MakeFoodie
//
//  Created by M06-3 on 7/21/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class AllReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
