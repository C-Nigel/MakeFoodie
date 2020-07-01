//
//  User.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 1/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class User: NSObject {
    var email: String
    var username: String
    var dob: String
    var gender: String
    var phoneNo: String
    var password: String
    
    init(email: String, username: String, dob: String, gender: String, phoneNo: String, password: String){
        self.email = email
        self.username = username
        self.dob = dob
        self.gender = gender
        self.phoneNo = phoneNo
        self.password = password
    }

}
