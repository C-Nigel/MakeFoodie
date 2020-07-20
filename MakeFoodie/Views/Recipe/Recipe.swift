//
//  Recipe.swift
//  MakeFoodie
//
//  Created by ITP312Grp2 on 8/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class Recipe: Codable {
    var recipeID: String
    var title: String
    var desc: String
    var ingredients: String
    var instructions: String
    var thumbnail: Image
    var reviews: Dictionary<String, Dictionary<String, String>>
    var uid: String
    
    init(recipeID: String, title: String, desc: String, ingredients: String, instructions: String, thumbnail: Image, reviews: Dictionary<String, Dictionary<String, String>>, uid: String){
        
        self.recipeID = recipeID
        self.title = title
        self.desc = desc
        self.ingredients = ingredients
        self.instructions = instructions
        self.thumbnail = thumbnail
        self.reviews = reviews
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
