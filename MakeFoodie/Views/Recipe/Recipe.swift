//
//  Recipe.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 8/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class Recipe: NSObject {
    var title: String
    var desc: String
    var ingredients: Array<String>
    var instructions: String
    var thumbnail: String
    var username: String
    
    init(title: String, desc: String, ingredients: Array<String>, instructions: String, thumbnail: String, username: String){
        
        self.title = title
        self.desc = desc
        self.ingredients = ingredients
        self.instructions = instructions
        self.thumbnail = thumbnail
        self.username = username
        
    }
}
