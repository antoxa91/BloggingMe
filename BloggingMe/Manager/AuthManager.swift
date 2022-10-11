//
//  AuthManager.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

final class AuthManager {
    
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private init() {}
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    public func singUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            return
        }
        
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            ///Account created
            completion(true)
        }
    }
    
    public func singIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            return
        }
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func singInWithGoogle(signVC: SignInViewController, completion: @escaping (Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: signVC) { [weak self] user, error in
            
            //  let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken,
                  let email = user?.profile?.email,
                  let name = user?.profile?.name,
                  error == nil else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: authentication.accessToken)
            
            self?.auth.signIn(with: credential) { result, error in
                guard result != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
                //добавляем в Firestore Database
                self?.insertNewUser(name: name, email: email, profilePictureURL: nil)
            }
        }
    }
    
    public func insertNewUser(name: String, email: String, profilePictureURL: URL?) {
        let newUser = User(name: name, email: email, profilePictureURL: nil)
        DatabaseManager.shared.insert(user: newUser) { inserted in
            guard inserted else { return }
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(name, forKey: "name")
        }
    }
    
    public func singOut(completion: @escaping (Bool) -> Void) {
        do {
            try auth.signOut()
            completion(true)
        }
        catch {
            print(error)
            completion(false)
        }
    }
}
