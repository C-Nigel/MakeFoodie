//
//  Post.swift
//  MakeFoodie
//
//  Created by Chen Kang Ning on 7/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class Post: Codable {
    var id: String
    var title: String
    var price: Double
    var startTime: String
    var endTime: String
    var desc: String
    var thumbnail: Image
    var category: String
    var latitude: Double
    var longitude: Double
    var locationName: String
    var locationAddr: String
    var uid: String
        
    init(id: String, title: String, price: Double, startTime:String, endTime:String, desc: String, thumbnail: Image, category: String, latitude: Double, longitude: Double, locationName: String, locationAddr: String, uid: String)
    {
        self.id = id
        self.title = title
        self.price = price
        self.startTime = startTime
        self.endTime = endTime
        self.desc = desc
        self.thumbnail = thumbnail
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = locationName
        self.locationAddr = locationAddr
        self.uid = uid
    }
    
    struct Image: Codable {
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
