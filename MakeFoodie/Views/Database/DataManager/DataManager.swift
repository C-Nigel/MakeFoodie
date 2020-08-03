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
    static func loadOrdersBasedOnUID(onComplete: (([Order]) -> Void)?)
      {
         db.collection("order").getDocuments { (data, err) in
         var orderList : [Order] = []
             if let err = err
             { // Handle errors here.
     //
                 print("Error getting documents: \(err)") }
             else
             {
                 for document in data!.documents{
                     let userss = try? document.data(as: Order.self)!
                     if userss != nil{

                        let user = Auth.auth().currentUser
                        if let user = user {
                          
                            let uidd: String = user.uid
                            if uidd == userss!.selleruid{
                                orderList.append(userss!)
                                print("1")
                            }
                           
                        }
                              
                        
                        
                         
                     }
                 }
           }
    
             onComplete?(orderList)
             
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
    static func insertOrReplaceOrder(_ ordersvar: Order)
    {
        try? db.collection("order")
            .document(ordersvar.buyeruid)
            .setData(from: ordersvar, encoder: Firestore.Encoder())
        {
            err in
            if let err = err {
                print("Error adding document: \(err)")
                
            } else { print("Document successfully added!")
     } }
    }
    
    //MARK: NIGEL
    
    static var names = [(String, String)]()
    
    
    // create a new record when user follows a post
    static func insertRecipeAndPosttFollowData(followeruid: String, following: String, type: String)
    {

        // Adding a document with a specific document ID / Or Replacing the data for a specific document ID
        db.collection("follow").document(type + "_" + followeruid + "_" + String(following)).setData(["followeruid":followeruid, "following": following, "type": type])
    }

    // retrieve a specific post that the specific user has followed post
    static func retrieveRecipeAndPosttFollowData(followeruid: String, following: String, type: String, completed: @escaping (_ documentExist: Bool) -> ())
    {
        var documentExist: Bool = false
        // get a specific document besed on the specific document ID
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
            // return true if document requested exist and is not nil
            print("retrieve data:" + String(documentExist))
            completed(documentExist)
        }
    }
    
    //remove followed post data when the user unfollows a psot
    static func deleteRecipeAndPosttFollowData(followeruid: String, following: String, type: String)
    {
        // delete specific document besed on specific document ID
        db.collection("follow").document(type + "_" + followeruid + "_" + String(following)).delete()
    }
    
    //retrieve all followed post data for the currently logged in user
    static func getFollowedPostIDByUID(onComplete: @escaping (_ FollowedPost: QuerySnapshot) -> ())
    {
        // retrieve all data where followeruid matches the logged in user
        db.collection("follow").whereField("type", isEqualTo: "post").whereField("followeruid", isEqualTo: Auth.auth().currentUser!.uid).getDocuments()
        {
            (QuerySnapshot, err) in
            if let err = err
            {
                print("Unable to get all user followed post: \(err)")
            }
            else
            {
                onComplete(QuerySnapshot!)
            }
        }
    }
    
    // get all post from all categories
    static func getAllPost(onComplete: @escaping (_ post: [Post]) -> ())
    {
        db.collection("post").getDocuments()
        {
            // get all items from firestore and store inside Item array
            (querySnapshot, err) in

            var itemList : [Post] = []

            if let err = err
            {
                // handles error here

                print("Error getting all post items: \(err)")
            }
            else
            {
                for document in querySnapshot!.documents
                {
                    // this line tells Firestore to retrieve all fields and update it into our Item object automatically.

                    // The requires the Movie object to implement the Codable protocol

                    let item = try? document.data(as: Post.self)!

                    if item != nil
                    {
                        itemList.append(item!)
                        itemList.shuffle()

                        // Once we have compeleted processing, call the onComplete closure passed in by the caller
                        onComplete(itemList)
                    }
                }
            }
        }
    }
    
    // get post details by specific post ID
    static func getFollowedPostDetailsByID(postID: String, onComplete: @escaping (_ postDetails: postDetails) -> ())
    {
        db.collection("post").document(postID).getDocument()
        {
            (QuerySnapshot, err) in
            if let err = err
            {
                print("error getting post details by ID: \(err)")
            }
            else
            {
                let item = try? QuerySnapshot!.data(as: postDetails.self)!
                // return all details
                onComplete(item!)
            }
        }
    }
    
    // get the list of categories based on the posts the user has followed
    // goes through followed posts and extract the category which the post is in
    // and append it into a list, and return
    static func getListOfCategories(followedPost: QuerySnapshot, onComplete: @escaping (_ categories: [String]) -> ())
    {
        var addedCategories : [String] = []
        for document in followedPost.documents
        {
            var categories:[String] = []
            let item = try? document.data(as: Follow.self)!
            getFollowedPostDetailsByID(postID: item!.following) { (postDetails) in
                if addedCategories.contains(postDetails.category) == false
                {
                    addedCategories.append(postDetails.category)
                    categories.append(postDetails.category)
                }
                // return the list of categories
                onComplete(categories)
            }
        }
    }
    
    // called in viewDidLoad
    // loads what post should be recommended to the user
    static func loadRecomendedItems(onComplete: (([Post]) -> Void)?)
    {
        var itemList : [Post] = []
        // testing algorithm v2
        
        getFollowedPostIDByUID { (followedPost) in
            
            if followedPost.count == 0
            {
                // means user has not followed any post
                // if so, recommend from all categories
                getAllPost { (postItems) in
                    onComplete!(postItems)
                }
            }
            else
            {
                getListOfCategories(followedPost: followedPost) { (listOfCategories) in
                    for category in listOfCategories
                    {
                        db.collection("post").whereField("category", isEqualTo: category).getDocuments()
                        {
                            (QuerySnapshot, err) in
                            if let err = err
                            {
                                print("error getting post by list of category: \(err)")
                            }
                            else
                            {
                                for items in QuerySnapshot!.documents
                                {
                                    let item = try? items.data(as: Post.self)!
                                    
                                    if item != nil
                                    {
                                        if item?.uid != Auth.auth().currentUser?.uid
                                        {
                                            itemList.append(item!)
                                            itemList.shuffle()
                                            // return all the items to be recommended
                                            onComplete?(itemList)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // when the owner of the post deletes her created post,
    // all users that thas followed that post will not be able to see the post
    static func deleteAllfollowers(id: String, type: String)
    {
        db.collection("follow").whereField("following", isEqualTo: id).whereField("type", isEqualTo: type).getDocuments()
        {
            (QuerySnapshot, err) in
            if let err = err
            {
                print("error deleting followed users \(err)")
            }
            else
            {
                for i in QuerySnapshot!.documents
                {
                    i.reference.delete()
                }
            }
        }
    }
    
    //MARK: follow seague tabs
    //loads all post in which the logged in user has followed
    static func loadFollowPostItems(onComplete: (([Post]) -> Void)?)
    {
        let userUID = Auth.auth().currentUser?.uid
        var followList : [Follow] = []
        var postItems : [Post] = []
        
        // retrieve all docuemnts
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
                        if item?.type == "post" && item?.followeruid == userUID
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
                        let item = try? querySnapshot!.data(as: Post.self)!
                        postItems.append(item!)
                    }
                    // Once we have compeleted processing, call the onComplete closure passed in by the caller
                    onComplete?(postItems)
                }
            }
        }
    }
    
    static func loadFollowRecipeItems(onComplete: (([recipeDetails]) -> Void)?)
    {
        let userUID = Auth.auth().currentUser?.uid
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
                        if item?.type == "recipes" && item?.followeruid == userUID
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
    
    static func getUsernameByUID(uid: String, onComplete: @escaping (_ username: String) -> ())
    {
        db.collection("user").whereField("uid", isEqualTo: uid).getDocuments()
        {
            (QuerySnapshot, err) in
            if  let err = err
            {
                print("error getting user's name: \(err)")
            }
            else
            {
                for document in QuerySnapshot!.documents
                {
                    let item = try? document.data(as: userDetails.self)!
                    onComplete(item!.username)
                }
            }
        }
    }
    
    //MARK: ZOE
    
    //add or edit recipe
    static func insertOrReplaceRecipe(_ recipe: Recipe) {
        try? db.collection("recipes")
            .document(String(recipe.recipeID))
            .setData(from: recipe, encoder: Firestore.Encoder()) {
                 err in
                 if let err = err { print("Error adding document: \(err)")
                    
                 } else { print("Document successfully added!")
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
    
    //delete recipe
    static func deleteRecipe(_ recipe: Recipe) {            db.collection("recipes").document(recipe.recipeID).delete() { err in

        if let err = err {
            print("Error removing document: \(err)")
        }
        else {
            print("Document successfully removed!") }
        }
    }

    
    
    // MARK: KANG NING
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
