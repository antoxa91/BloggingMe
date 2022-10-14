//
//  ProfileHeaderView.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 14.10.2022.
//

import UIKit

final class ProfileHeaderView: UIView {
    
    let profilePhoto: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(profilePhoto)
        addSubview(emailLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profilePhoto.layer.cornerRadius = profilePhoto.frame.size.width/2
        emailLabel.font = .systemFont(ofSize: frame.width/20, weight: .bold)
    }
}


// MARK: - Constraints
extension ProfileHeaderView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            profilePhoto.centerXAnchor.constraint(equalTo: centerXAnchor),
            profilePhoto.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            profilePhoto.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            profilePhoto.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            
            emailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
