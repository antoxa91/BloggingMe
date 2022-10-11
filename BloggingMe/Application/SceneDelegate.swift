//
//  SceneDelegate.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        
        let vc: UIViewController
        if AuthManager.shared.isSignedIn {
            vc = TabBarController()
        } else {
            let signVC = SignInViewController()
            signVC.navigationItem.largeTitleDisplayMode = .always
            let navVC = UINavigationController(rootViewController: signVC)
            navVC.navigationBar.prefersLargeTitles = true
            vc = navVC
        }
        //TODO: update vc to sign in vc if not signed in
        window?.rootViewController = vc
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

