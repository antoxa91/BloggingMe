//
//  StorageManager.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let container = Storage.storage()
    
    private init() {}
    
    static func userEmail(_ emailAddress: String) -> String {
        var userEmail = emailAddress.replacingOccurrences(of: "@", with: "_")
        userEmail = userEmail.replacingOccurrences(of: ".", with: "_")
        return userEmail
    }
    
    public func uploadUserProfilePicture(email: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        let path = StorageManager.userEmail(email)
        
        guard let jpegData = image?.jpegData(compressionQuality: 0.5) else { return }
        
        container
            .reference(withPath: "profile_pictures/\(path)/photo.png")
            .putData(jpegData) { metadata, error in
                guard metadata != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    public func downloadURLForProfilePicture(path: String, completion: @escaping (URL?) -> Void) {
        container.reference(withPath: path)
            .downloadURL { url, _ in
                completion(url)
            }
    }
    
    public func uploadBlogHeaderImage(email: String, image: UIImage?, postId: String, completion: @escaping (Bool) -> Void) {
        let path = StorageManager.userEmail(email)
        
        guard let jpegData = image?.jpegData(compressionQuality: 0.8) else { return }
        
        container
            .reference(withPath: "post_headers/\(path)/\(postId).png")
            .putData(jpegData) { metadata, error in
                guard metadata != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    public func downloadURLForPostHeader(email: String, postId: String, completion: @escaping (URL?) -> Void) {
        let path = StorageManager.userEmail(email)
        
        container
            .reference(withPath: "post_headers/\(path)/\(postId).png")
            .downloadURL { url, _ in
                completion(url)
            }
    }
    
    public func deleteBlogHeaderImage(email: String, postId: String, completion: @escaping (Bool) -> Void) {
        let path = StorageManager.userEmail(email)
        
        container
            .reference(withPath: "post_headers/\(path)/\(postId).png")
            .delete { error in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
    }
}
