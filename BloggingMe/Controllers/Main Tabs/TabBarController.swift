//
//  TabBarController.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.additionalSafeAreaInsets.bottom = 15
        setTabBarAppearance()
        setupControllers()
    }
    
    private func setupControllers() {
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "email") else { return }
        
        let home = HomeViewController()
        home.title = "Home"
        home.navigationItem.largeTitleDisplayMode = .always
        let homeVC = UINavigationController(rootViewController: home)
        homeVC.navigationBar.prefersLargeTitles = true
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        
        let profile = ProfileViewController(currentEmail: currentUserEmail)
        profile.title = "Profile"
        profile.navigationItem.largeTitleDisplayMode = .always
        let profileVC = UINavigationController(rootViewController: profile)
        profileVC.navigationBar.prefersLargeTitles = true
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
        
        let createPost = CreateNewPostViewController()
        createPost.title = "Create Post"
        let createPostVC = UINavigationController(rootViewController: createPost)
        createPostVC.tabBarItem = UITabBarItem(title: "Create Post", image: UIImage(systemName: "plus.circle"), tag: 3)
        
        setViewControllers([homeVC, createPostVC, profileVC], animated: true)
    }
    
    private func setTabBarAppearance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 12
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2

        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height
            ),
            cornerRadius: height / 2
        )
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor(named: "CompButtonBackground")!.cgColor
        roundLayer.shadowRadius = 5
        roundLayer.shadowOpacity = 0.5
        roundLayer.shadowColor = UIColor.blue.cgColor
        roundLayer.shadowOffset = CGSize(width: 0, height: -2)

        tabBar.tintColor = UIColor(named: "TabBarTint")
        tabBar.unselectedItemTintColor = .systemGray
    }
}
