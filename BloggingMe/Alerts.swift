//
//  Alerts.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 03.11.2022.
//

import UIKit

struct Alert {
    
    private static func showSimpleAlert(vc: UIViewController, title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        DispatchQueue.main.async {
            vc.present(ac, animated: true, completion: nil)
        }
    }
    
    private static func showChangeActionSheet(vc: UIViewController, title: String, message: String, completion: @escaping() -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "OK", style: .default) {_ in
            completion()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        DispatchQueue.main.async {
            vc.present(ac, animated: true, completion: nil)
        }
    }
    
    
    static func showAlert(vc: UIViewController, title: String, message: String) {
        showSimpleAlert(vc: vc, title: title.localizedCapitalized, message: message)
    }
    
    static func showErrorAlert(vc: UIViewController, message: String) {
        showSimpleAlert(vc: vc, title: "Error", message: message)
    }
    
    static func showCompletionActionSheet(vc: UIViewController, title: String, message: String, completion: @escaping() -> Void) {
        showChangeActionSheet(vc: vc, title: title, message: message, completion: completion)
    }
}
