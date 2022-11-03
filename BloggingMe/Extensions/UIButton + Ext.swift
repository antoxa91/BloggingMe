//
//  UIButton + Ext.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 03.11.2022.
//

import UIKit

extension UIButton {
    func animateError() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 10, animations: {
            self.alpha = 0.5
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.transform = .identity
            self.alpha = 1
        })
    }
}
