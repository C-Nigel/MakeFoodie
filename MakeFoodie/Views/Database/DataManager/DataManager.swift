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

    //Create a new database if it does not already exists
    static let db = Firestore.firestore()
    static func createDatabase()
    {

    }
    static func insertOrReplaceMovie(_ usersvar: User)
    {
        try? db.collection("user")
            .document(usersvar.email)
            .setData(from: usersvar, encoder: Firestore.Encoder())
        {
            err in
            if let err = err {
                print("Error adding document: \(err)")
            } else { print("Document successfully added!")
     } }
    }
}
