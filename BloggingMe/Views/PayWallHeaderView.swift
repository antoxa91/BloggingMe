//
//  PayWallHeaderView.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 07.10.2022.
//

import UIKit

class PayWallHeaderView: UIView {
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "crown.fill"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerImageView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),
            headerImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4)
        ])
    }
}
