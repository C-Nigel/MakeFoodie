//
//  Item.swift
//  MakeFoodie
//
//  Created by NIgel Cheong on 10/6/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class Item: NSObject {
    var title: String
    var price: Int
    var desc: String
    var imageName: String
    var userName: String
    
    init(title: String, price: Int, desc: String, imageName: String, userName: String)
    {
        self.title = title
        self.price = price
        self.desc = desc
        self.imageName = imageName
        self.userName = userName
    }
}
