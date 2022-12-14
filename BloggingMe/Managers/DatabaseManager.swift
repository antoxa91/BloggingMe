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
    
    let database = Firestore.firestore()
    private init() {}
    
    public func insertPost(blogPost: BlogPost, email: String, completion: @escaping(Bool) -> Void) {
        let path = StorageManager.userEmail(email)
        
        let data: [String: Any] = [
            "id": blogPost.identifier,
            "title": blogPost.title,
            "body": blogPost.text,
            "created": blogPost.timestamp,
            "headerImageURL": blogPost.headerImageUrl?.absoluteString ?? ""
        ]
        
        database
            .collection("users")
            .document(path)
            .collection("posts")
            .document(blogPost.identifier)
            .setData(data) { error in
                completion(error == nil)
            }
    }
    
    public func getAllPosts(completion: @escaping([BlogPost]) -> Void) {
        database
            .collection("users")
            .getDocuments { [weak self] snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0.data()}), error == nil else {
                    return
                }
                
                let emails: [String] = documents.compactMap { return $0["email"] as? String }
                guard !emails.isEmpty else {
                    completion([])
                    return
                }
                
                let group = DispatchGroup()
                var result: [BlogPost] = []
                
                for email in emails {
                    group.enter()
                    self?.getUserPosts(for: email) { userPosts in
                        defer {
                            group.leave()
                        }
                        result.append(contentsOf: userPosts)
                    }
                }
                
                group.notify(queue: .global()) {
                    completion(result)
                }
            }
    }
    
    public func getUserPosts(for email: String, completion: @escaping([BlogPost]) -> Void) {
        let path = StorageManager.userEmail(email)

        database
            .collection("users")
            .document(path)
            .collection("posts")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents.compactMap({ $0.data() }),
                      error == nil else {
                    return
                }
                
                let posts: [BlogPost] = documents.compactMap({ dictionary in
                    guard let id = dictionary["id"] as? String,
                          let title = dictionary["title"] as? String,
                          let body = dictionary["body"] as? String,
                          let created = dictionary["created"] as? TimeInterval,
                          let imageUrlString = dictionary["headerImageURL"] as? String else {
                        print("Invalid post fetch conversion")
                        return nil
                    }
                    
                    let post = BlogPost(
                        identifier: id,
                        title: title,
                        timestamp: created,
                        headerImageUrl: URL(string: imageUrlString),
                        text: body
                    )
                    return post
                })
                
                completion(posts)
            }
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
        let path = StorageManager.userEmail(email)
        
        database
            .collection("users")
            .document(path)
            .getDocument { snapshot, error in
                guard let data = snapshot?.data() as? [String: String],
                      let name = data["name"],
                      error == nil else {
                    return
                }
                
                let ref = data["profile_photo"]
                let user = User(name: name, email: email, profilePictureRef: ref)
                completion(user)
            }
    }
    
    public func updateProfilePhoto(email: String, completion: @escaping (Bool) -> Void) {
        let path = StorageManager.userEmail(email)
        
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
    
    public func deletePost(email: String, postId: String, blogPost: BlogPost, completion: @escaping (Bool) -> Void) {
        let path = StorageManager.userEmail(email)
        
        database
            .collection("users")
            .document(path)
            .collection("posts")
            .document(blogPost.identifier)
            .delete { error in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
    }
    
    public func updateProfileName(email: String, newName: String, completion: @escaping (Bool) -> Void) {
        let path = StorageManager.userEmail(email)
        
        let databaseRef = database
            .collection("users")
            .document(path)
        
        databaseRef.updateData(["name": newName])
    }
}
