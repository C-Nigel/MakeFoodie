//
//  Item.swift
//  MakeFoodie
//
//  Created by NIgel Cheong on 10/6/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

//class Item: Codable {
//    var title: String
//    var price: Float
//    var desc: String
//    var imageName: String
//    var userName: String
//    
//    init(title: String, price: Float, desc: String, imageName: String, userName: String)
//    {
//        self.title = title
//        self.price = price
//        self.desc = desc
//        self.imageName = imageName
//        self.userName = userName
//    }
//}

class Item: Codable {
    var id: String
    var title: String
    var price: Decimal
    var desc: String
    var thumbnail: Image
    var category: String
    var uid: String
        
    init(id:String, title: String, price: Decimal, desc: String, thumbnail: Image, category: String, uid: String)
    {
        self.id = id
        self.title = title
        self.price = price
        self.desc = desc
        self.thumbnail = thumbnail
        self.category = category
        self.uid = uid
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

