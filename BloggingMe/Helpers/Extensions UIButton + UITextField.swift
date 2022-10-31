//
//  Extensions UIButton + UITextField.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 07.10.2022.
//

import UIKit

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
    
    func addDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.resignFirstResponder))
        toolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = toolbar
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

extension UITextView {
    func addDoneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.resignFirstResponder))
        toolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = toolbar
    }
}
