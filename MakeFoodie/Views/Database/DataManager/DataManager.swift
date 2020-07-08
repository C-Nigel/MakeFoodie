//
//  DataManager.swift
//  MakeFoodie
//
//  Created by NIgel Cheong on 7/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class DataManager: NSObject {

    //Create a new database if it does not already exists
    
    static func createDatabase()
    {
        SQLiteDB.sharedInstance.execute(sql:
        "CREATE TABLE IF NOT EXISTS " + "Recipe ( " + " rID int primary key autoincrement, " + " username text not null, " + "rTitle text not null, " + " rDescription text not null, " + " rIngredients text not null, " + " rInstructions text not null" +
        " rThumbnail text )")
    }
    
}
