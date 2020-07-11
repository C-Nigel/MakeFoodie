//
//  User.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 1/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class User: Codable {

    var username: String
    var dob: String
    var gender: String
    var phoneNo: String
    
    var description: String
    var imagelink: Image
    var uid: String
    
    init(username: String, dob: String, gender: String, phoneNo: String, description: String, imagelink: Image,uid: String){

        self.username = username
        self.dob = dob
        self.gender = gender
        self.phoneNo = phoneNo
        self.description = description
        self.imagelink = imagelink
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
