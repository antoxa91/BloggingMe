//
//  ViewController.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        DispatchQueue.main.async {
            if !IAPManager.shared.isPremium() {
                let vc = PayWallViewController()
                
                self.present(vc, animated: true)
            }
        }
    }


}

