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
    
    public func uploadUserProfilePicture(email: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
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
    
    public func uploadHeaderImage(blogPost: BlogPost, image: UIImage?, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func downloadURLForPostHeader(blogPost: BlogPost, completion: @escaping (URL?) -> Void) {
        
    }
}
