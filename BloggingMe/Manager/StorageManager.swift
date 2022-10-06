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
    
    private let container = Storage.storage().reference()
    
    private init() {}
    
    public func uploadUserProfilePicture(email: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func downloadURLForProfilePicture(user: User, completion: @escaping (URL?) -> Void) {
        
    }
    
    public func uploadHeaderImage(blogPost: BlogPost, image: UIImage?, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func downloadURLForPostHeader(blogPost: BlogPost, completion: @escaping (URL?) -> Void) {
        
    }
}
