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
    var itemimage: Image
    var itemprice: String
    var quantity: String
    var postalcode: String
    var orderuid: String
    var status: String
        
    init(selleruid: String, buyeruid: String, itemname: String, itemimage: Image, itemprice: String, quantity: String, postalcode: String, orderuid: String, status: String){
        self.selleruid = selleruid
        self.buyeruid = buyeruid
        self.itemname = itemname
        self.itemimage = itemimage
        self.itemprice = itemprice
        self.quantity = quantity
        self.postalcode = postalcode
        self.orderuid = orderuid
        self.status = status
    }
    struct Image: Codable{
        let imageData: Data?
        
        init(withImage image: UIImage) {
            self.imageData = image.pngData()
        }

        func getImage() -> UIImage? {
            guard let imageData = self.imageData else {
                return nil
            }
            let image = UIImage(data: imageData)
            
            return image
        }
    }
}
