//
//  Item.swift
//  MakeFoodie
//
//  Created by NIgel Cheong on 10/6/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class Item: Codable {
    var title: String
    var price: Float
    var desc: String
    var imageName: String
    var userName: String
    
    init(title: String, price: Float, desc: String, imageName: String, userName: String)
    {
        self.title = title
        self.price = price
        self.desc = desc
        self.imageName = imageName
        self.userName = userName
    }
}
