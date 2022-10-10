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


extension UITextField {
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
