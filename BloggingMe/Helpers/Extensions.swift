//
//  Extensions.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 07.10.2022.
//

import UIKit

//TODO: - сверсать на констр и удалить это
extension UIView {
    var width: CGFloat {
        frame.size.width
    }
    
    var height: CGFloat {
        frame.size.height
    }
    
    var left: CGFloat {
        frame.origin.x
    }
    
    var right: CGFloat {
        left + width
    }
    
    var top: CGFloat {
        frame.origin.y
    }
    
    var bottom: CGFloat {
        top + height
    }
}

let button = UIButton(type: .custom)
extension UITextField {
    func enablePasswordToggle(){
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        rightView = button
        rightViewMode = .always
        button.alpha = 0.5
    }
    
    
    @objc func togglePasswordView(_ sender: Any) {
          isSecureTextEntry.toggle()
          button.isSelected.toggle()
      }
    
    func setupLeftImage(imageViewNamed: String) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(systemName: imageViewNamed)
        imageView.contentMode = .scaleAspectFit
        let imageContrainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageContrainerView.addSubview(imageView)
        leftView = imageContrainerView
        leftViewMode = .always
        self.tintColor = .lightGray
    }
}

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
