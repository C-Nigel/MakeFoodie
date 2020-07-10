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
    var uid: String
    
    init(username: String, dob: String, gender: String, phoneNo: String, description: String, uid: String){

        self.username = username
        self.dob = dob
        self.gender = gender
        self.phoneNo = phoneNo
        self.description = description
        self.uid = uid
    }

}
