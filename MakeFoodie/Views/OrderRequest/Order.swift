//
//  Order.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 22/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class Order: Codable {

    var selleruid: String
    var buyeruid: String
    var itemname: String
    var itemprice: String
    var address: String
    var status: String
        
    init(selleruid: String, buyeruid: String, itemname: String, itemprice: String, address: String, status: String){
        self.selleruid = selleruid
        self.buyeruid = buyeruid
        self.itemname = itemname
        self.itemprice = itemprice
        self.address = address
        self.status = status
    }
}
