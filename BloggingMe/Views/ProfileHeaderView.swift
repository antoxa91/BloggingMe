//
//  ProfileHeaderView.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 14.10.2022.
//

import UIKit

final class ProfileHeaderView: UIView {
    
    let gradient = CAGradientLayer()

    let profilePhoto: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.tintColor = UIColor(named: "ButtonBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = #colorLiteral(red: 0, green: 0.6885758638, blue: 0.8448309302, alpha: 1)
        return imageView
    }()
    
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0.7
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientView()
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
        gradient.frame = self.bounds
        profilePhoto.layer.cornerRadius = profilePhoto.frame.size.width/2
        emailLabel.font = UIFont(name: "OpenSans-SemiBold", size: frame.size.width / 23)
    }
    
    private func setupGradientView(){
        gradient.colors = [
            UIColor(red: 197/255, green: 188/255, blue: 246/255, alpha: 0.2).cgColor,
            UIColor(red: 162/255, green: 139/255, blue: 238/255, alpha: 0.4).cgColor,
            UIColor(red: 140/255, green: 111/255, blue: 234/255, alpha: 0.6).cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.locations = [0.1, 0.4, 1.0]
        gradient.cornerRadius = 20
        self.layer.addSublayer(gradient)
    }
}


// MARK: - Constraints
extension ProfileHeaderView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            profilePhoto.centerXAnchor.constraint(equalTo: centerXAnchor),
            profilePhoto.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -11),
            profilePhoto.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.44),
            profilePhoto.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.44),

            emailLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            emailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5),
            emailLabel.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.05)
        ])
    }
}
