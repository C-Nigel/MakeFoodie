//
//  Post.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 7/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class Post: NSObject {
    var title: String
    var price: Decimal
    var desc: String
    var thumbnail: String
    var category: String
    var userName: String
        
    init(title: String, price: Decimal, desc: String, thumbnail: String, category: String, userName: String)
    {
        self.title = title
        self.price = price
        self.desc = desc
        self.thumbnail = thumbnail
        self.category = category
        self.userName = userName
    }
}
