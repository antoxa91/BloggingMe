//
//  PayWallDescriptionView.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 07.10.2022.
//

import UIKit

class PayWallDescriptionView: UIView {
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Join BloggingMe Premium to read unlimited articles and browse thousands of posts!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "0.99$ / month"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(priceLabel)
        addSubview(descriptionLabel)
        translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionLabel.font = .systemFont(ofSize: frame.width/15, weight: .medium)
        priceLabel.font = .systemFont(ofSize: frame.width/18, weight: .regular)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            descriptionLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            
            priceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
