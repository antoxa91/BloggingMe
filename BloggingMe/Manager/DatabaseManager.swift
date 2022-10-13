//
//  DatabaseManager.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    public func insertPost(blogPost: BlogPost, user: User, completion: @escaping(Bool) -> Void) {
        
    }
    
    public func getAllPosts(completion: @escaping([BlogPost]) -> Void) {
        
    }
    
    public func getPosts(user: User, completion: @escaping([BlogPost]) -> Void) {
        
    }
    
    public func insertUser(_ user: User, completion: @escaping(Bool) -> Void) {
        let documentID = user.email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        let data = [
            "email": user.email,
            "name": user.name
        ]
        
        database
            .collection("users")
            .document(documentID)
            .setData(data) { error in
                completion(error == nil)
            }
    }
    
    public func getUser(email: String, completion: @escaping (User?) -> Void) {
        let documentID = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        database
            .collection("users")
            .document(documentID)
            .getDocument { snapshot, error in
                guard let data = snapshot?.data() as? [String: String],
                      let name = data["name"],
                      error == nil else {
                    return
                }
                
                var ref = data["profile_photo"]
                
                let user = User(name: name, email: email, profilePictureRef: ref)
                completion(user)
            }
    }
    
    public func updateProfilePhoto(email: String, completion: @escaping (Bool) -> Void) {
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        let photoReference = "profile_pictures/\(path)/photo.png"
        
        let databaseRef = database
            .collection("users")
            .document(path)
        
        databaseRef.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else { return }
            
            data["profile_photo"] = photoReference
            databaseRef.setData(data) { error in
                completion(error == nil)
            }
        }
    }
}
