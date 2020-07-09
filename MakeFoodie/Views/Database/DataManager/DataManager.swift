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
    
    //ADD NEW USER IN DATABASE OR REPLACE CURRENT INFO
    static func insertOrReplaceUser(_ usersvar: User)
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
    //CLEAR USER INFO dun touch pls:p
    static func deleteUSER(_ email: String) {
        db.collection("user").document(email).delete() {
        err in

         if let err = err {
         print("Error removing document: \(err)") } else {
         print("Document successfully removed!") }
         }
    }
    
    // ========================================================================================================================================================
    // ========================================================================================================================================================
    
    static func insertData()
    {

        // Adding a document with a specific document ID / Or Replacing the data for a specific document ID
        db.collection("users").document("esf6xvYfISw2DnEs9GBR").setData(["username":"durian"])
    }

    static func retrieveData()
    {
        db.collection("users").document("esf6xvYfISw2DnEs9GBR")
    }
    
    
    static func loadRecomendedItems(onComplete: (([Item]) -> Void)?)
    {
        db.collection("posts").getDocuments()
        {
            // get all items from firestore and store inside Item array
            (querySnapshot, err) in
            
            var itemList : [Item] = []
            
            if let err = err
            {
                // handles error here
                
                print("Error getting all items: \(err)")
            }
            else
            {
                for document in querySnapshot!.documents
                {
                    // this line tells Firestore to retrieve all fields and update it into our Item object automatically.
                    
                    // The requires the Movie object to implement the Codable protocol
                    
                    var item = try? document.data(as: Item.self) as! Item
                    
                    if item != nil
                    {
                        itemList.append(item!)
                    }
                }
            }
            // Once we have compeleted processing, call the onComplete closure passed in by the caller
            onComplete?(itemList)
        }
    }
}
