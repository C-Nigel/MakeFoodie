//
//  DataManager.swift
//  MakeFoodie
//
//  Created by NIgel Cheong on 7/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class DataManager: NSObject {

    static let db = Firestore.firestore()
    
    static func insertData()
    {
        // Adding a document with a specific document ID / Or Replacing the data for a specific document ID
        db.collection("users").document("esf6xvYfISw2DnEs9GBR").setData(["username":"durian"])
    }
    
    static func retrieveData()
    {
        db.collection("users").document("esf6xvYfISw2DnEs9GBR")
    }
}
