//
//  DataManager.swift
//  MakeFoodie
//
//  Created by NIgel Cheong on 7/7/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


class DataManager: NSObject {

    //Create a new database if it does not already exists
    static let db = Firestore.firestore()
    
    //ADD NEW USER IN DATABASE OR REPLACE CURRENT INFO
    static func insertOrReplaceUser(_ usersvar: User)
    {
        try? db.collection("user")
            .document(usersvar.uid)
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
    static func loadUser(onComplete: (([User]) -> Void)?)
     {
        db.collection("user").getDocuments { (data, err) in
        var userList : [User] = []
            if let err = err
            { // Handle errors here.
    //
                print("Error getting documents: \(err)") }
            else
            {
                for document in data!.documents{
                    let userss = try? document.data(as: User.self)!
                    if userss != nil{
                        userList.append(userss!)
                        
                    }
                }
          }
   
            onComplete?(userList)
            
        } }
    static func loadFollowers(onComplete: (([Follow]) -> Void)?)
      {
         db.collection("follow").getDocuments { (data, err) in
         var followList : [Follow] = []
             if let err = err
             { // Handle errors here.
     //
                 print("Error getting documents: \(err)") }
             else
             {
                 for document in data!.documents{
                     let userss = try? document.data(as: Follow.self)!
                     if userss != nil{
                         followList.append(userss!)
                         
                     }
                 }
           }
    
             onComplete?(followList)
             
         } }
    
    // ========================================================================================================================================================
    // ========================================================================================================================================================
    // Nigel
    
    static var names = [(String, String)]()
    
    static func insertRecipeAndPosttFollowData(followeruid: String, following: String, type: String)
    {

        // Adding a document with a specific document ID / Or Replacing the data for a specific document ID
        db.collection("follow").document(type + "_" + followeruid + "_" + String(following)).setData(["followeruid":followeruid, "following": following, "type": type])
    }

    static func retrieveRecipeAndPosttFollowData(followeruid: String, following: String, type: String, completed: @escaping (_ documentExist: Bool) -> ())
    {
        var documentExist: Bool = false
        db.collection("follow").document(type + "_" + followeruid + "_" + String(following)).getDocument
        {
            (document, error) in
            if let document = document, document.exists
            {
                let documentDetails = document.data() ?? nil
                
                if documentDetails != nil
                {
                    documentExist = true
                }
            }
            print("retrieve data:" + String(documentExist))
            completed(documentExist)
        }
    }
    
    static func deleteRecipeAndPosttFollowData(followeruid: String, following: String, type: String)
    {
        db.collection("follow").document(type + "_" + followeruid + "_" + String(following)).delete()
    }
    
    
    static func loadRecomendedItems(onComplete: (([Item]) -> Void)?)
    {
        db.collection("post").getDocuments()
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
                    
                    let item = try? document.data(as: Item.self)!
                    
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
    
    static func loadFollowPostItems(onComplete: (([postDetails]) -> Void)?)
    {
        var followList : [Follow] = []
        var postItems : [postDetails] = []
        
        db.collection("follow").getDocuments()
        {
            // get all items from firestore and store inside Item array
            (querySnapshot, err) in
            
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
                    
                    let item = try? document.data(as: Follow.self)!
                    
                    if item != nil
                    {
                        if item?.type == "post"
                        {
                            followList.append(item!)
                        }
                    }
                }
            }
            
            for i in followList
            {
                db.collection("post").document(String(i.following)).getDocument()
                {
                    // get all items from firestore and store inside Item array
                    (querySnapshot, err) in
                                        
                    if let err = err
                    {
                        // handles error here
                        
                        print("Error getting all items: \(err)")
                    }
                    else
                    {
                        let item = try? querySnapshot!.data(as: postDetails.self)!
                        
                        if item != nil
                        {
                            for (key, value) in names
                            {
                                if key == item?.uid
                                {
                                    item?.uid = value
                                }
                            }
                            //item?.uid = getNameByUID(UID: item!.uid)
                            postItems.append(item!)
                        }
                        
                    }
                    // Once we have compeleted processing, call the onComplete closure passed in by the caller
                    onComplete?(postItems)
                }
            }
        }
    }
    
    static func loadFollowRecipeItems(onComplete: (([recipeDetails]) -> Void)?)
    {
        var followList : [Follow] = []
        var recipeItems : [recipeDetails] = []
        
        db.collection("follow").getDocuments()
        {
            // get all items from firestore and store inside Item array
            (querySnapshot, err) in
            
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
                    
                    let item = try? document.data(as: Follow.self)!
                    
                    if item != nil
                    {
                        if item?.type == "recipes"
                        {
                            followList.append(item!)
                        }
                    }
                }
            }
            
            for i in followList
            {
                db.collection("recipes").document(String(i.following)).getDocument()
                {
                    // get all items from firestore and store inside Item array
                    (querySnapshot, err) in
                                        
                    if let err = err
                    {
                        // handles error here
                        
                        print("Error getting all items: \(err)")
                    }
                    else
                    {
                        let item = try? querySnapshot!.data(as: recipeDetails.self)!
                        
                        if item != nil
                        {
                            for (key, value) in names
                            {
                                if key == item?.uid
                                {
                                    item?.uid = value
                                }
                            }
                            //item?.uid = getNameByUID(UID: item!.uid)
                            recipeItems.append(item!)
                        }
                        
                    }
                    // Once we have compeleted processing, call the onComplete closure passed in by the caller
                    onComplete?(recipeItems)
                }
            }
        }
    }
    
    static func loadFollowingUserItems(onComplete: (([userDetails]) -> Void)?)
    {
        let userUID = Auth.auth().currentUser?.uid
        var followList : [followForUsers] = []
        var followingUserItems : [userDetails] = []
        
        db.collection("follow").getDocuments()
        {
            // get all items from firestore and store inside Item array
            (querySnapshot, err) in
            
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
                    
                    let item = try? document.data(as: followForUsers.self)!
                    
                    if item != nil
                    {
                        if item?.type == "user" && item?.following == userUID
                        {
                            followList.append(item!)
                        }
                    }
                }
            }
            
            for i in followList
            {
                db.collection("user").document(String(i.followeruid)).getDocument()
                {
                    // get all items from firestore and store inside Item array
                    (querySnapshot, err) in
                                        
                    if let err = err
                    {
                        // handles error here
                        
                        print("Error getting all items: \(err)")
                    }
                    else
                    {
                        let item = try? querySnapshot!.data(as: userDetails.self)!
                        
                        if item != nil
                        {
                            for (key, value) in names
                            {
                                if key == item?.uid
                                {
                                    item?.uid = value
                                }
                            }
                            //item?.uid = getNameByUID(UID: item!.uid)
                            followingUserItems.append(item!)
                        }
                        
                    }
                    // Once we have compeleted processing, call the onComplete closure passed in by the caller
                    onComplete?(followingUserItems)
                }
            }
        }
    }
    
    static func loadUserFollowingItems(onComplete: (([userDetails]) -> Void)?)
    {
        let userUID = Auth.auth().currentUser?.uid
        var followList : [followForUsers] = []
        var followingUserItems : [userDetails] = []
        
        db.collection("follow").getDocuments()
        {
            // get all items from firestore and store inside Item array
            (querySnapshot, err) in
            
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
                    
                    let item = try? document.data(as: followForUsers.self)!
                    
                    if item != nil
                    {
                        if item?.type == "user" && item?.followeruid == userUID
                        {
                            followList.append(item!)
                        }
                    }
                }
            }
            
            for i in followList
            {
                db.collection("user").document(String(i.following)).getDocument()
                {
                    // get all items from firestore and store inside Item array
                    (querySnapshot, err) in
                                        
                    if let err = err
                    {
                        // handles error here
                        
                        print("Error getting all items: \(err)")
                    }
                    else
                    {
                        let item = try? querySnapshot!.data(as: userDetails.self)!
                        
                        if item != nil
                        {
                            for (key, value) in names
                            {
                                if key == item?.uid
                                {
                                    item?.uid = value
                                }
                            }
                            //item?.uid = getNameByUID(UID: item!.uid)
                            followingUserItems.append(item!)
                        }
                        
                    }
                    // Once we have compeleted processing, call the onComplete closure passed in by the caller
                    onComplete?(followingUserItems)
                }
            }
        }
    }
    
    static func getNameByUID()
    {
        db.collection("user").getDocuments()
        {
            (querySnapshot, err) in
            
            if let err = err
            {
                print("Error getting user by UID: \(err)")
            }
            else
            {
                for document in querySnapshot!.documents
                {
                    let item = try? document.data(as: userDetails.self)!
                    
                    if item != nil
                    {
                        names.append((item!.uid,item!.username))
                    }
                }
            }
        }
    }
    
    //zoe//
    //add or edit recipe
    static func insertOrReplaceRecipe(_ recipe: Recipe) {
        try? db.collection("recipes")
            .document(String(recipe.recipeID))
            .setData(from: recipe, encoder: Firestore.Encoder()) {
                 err in
                 if let err = err { print("Error adding document: \(err)") } else { print("Document successfully added!")
             }
                
        }
    }
    
    //load recipe list
    static func loadRecipes(onComplete: (([Recipe]) -> Void)?) {
        db.collection("recipes").getDocuments() {
            (querySnapshot, err) in
                var recipeList : [Recipe] = []
                if let err = err { // Handle errors here.
                    print("Error getting documents: \(err)")
                    
                }
                else {
                    for document in querySnapshot!.documents {
                        let recipe = try? document.data(as: Recipe.self)!
                        if recipe != nil {
                            recipeList.append(recipe!)
                            
                        }
                    }
                }
                onComplete?(recipeList)
            }
        
    }
    
    // Kang Ning
    // Loads from firebase and convert to Post array
    static func loadPosts(onComplete: (([Post]) -> Void)?) {
        // getDocuments loads full list of posts in descending order of id field
        db.collection("post").getDocuments() {
            (querySnapshot, err) in
            
            var postList : [Post] = []
            
            if let err = err {
                // Handle errors here.
                print("Error getting documents: \(err)") // Print err to console
                
            }
            else {
                for document in querySnapshot!.documents {
                    // Retrieve fields and update into Post object
                    let post = try? document.data(as: Post.self)!
                    if post != nil {
                        postList.append(post!)
                        
                    }
                }
            }
            // Call onComplete when completed processing
            onComplete?(postList)
        }
    }
    
    // Load post by category name
    static func loadPostsByCategory(_ category:String, onComplete: (([Post]) -> Void)?) {
        db.collection("post").whereField("category", isEqualTo: category).order(by: "id", descending: true).getDocuments() {
            (querySnapshot, err) in
                
            var postList : [Post] = []
                
            if let err = err {
                // Handle errors here.
                print("Error getting documents: \(err)") // Print err to console
                    
            }
            else {
                for document in querySnapshot!.documents {
                    // Retrieve fields and update into Post object
                    let post = try? document.data(as: Post.self)!
                    if post != nil {
                        postList.append(post!)
                    }
                }
            }
            // Call onComplete when completed processing
            onComplete?(postList)
        }
    }
    
    // Add or Edit Post
    static func insertOrEditPost(_ post: Post) {
        try? db.collection("post")
            .document(String(post.id))
            .setData(from: post, encoder: Firestore.Encoder()) // Closure omitted because last parameter accepts function
        {
                
            err in
                
            if let err = err {
                print("Error adding document: \(err)")
            }
            else {
                print("Document successfully added/modified!")
            }
        }
    }
    
    // Deletes a post from db
     static func deletePost(_ post: Post) {
        db.collection("post").document(String(post.id)).delete() { err in
         if let err = err {
            print("Error removing document: \(err)") }
         else {
            print("Document successfully removed!") }
         }
    }
    
    
}
