//
//  PostPreviewTableViewCell.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 18.10.2022.
//

import UIKit

final class PostPreviewTableViewCell: UITableViewCell {
    
    static let identifier = "PostPreviewTableViewCell"
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.shadowColor = UIColor.green.cgColor
        imageView.layer.shadowOffset = .init(width: 4, height: 4)
        imageView.layer.shadowOpacity = 0.9
        return imageView
    }()
    
    private let postTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.highlightedTextColor = .purple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(postImageView)
        contentView.addSubview(postTitleLabel)
        backgroundColor = UIColor(named: "CellBackground")
        layer.cornerRadius = 20
        layer.borderWidth = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        postTitleLabel.font = UIFont(name: "OpenSans-SemiBold", size: frame.size.width/22)
        setConstraints()
        layer.borderColor = UIColor(named: "PrimaryBackground")!.cgColor

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postTitleLabel.text = nil
        postImageView.image = nil
    }
    
    func configure(with viewModel: PostPreviewTableViewCellViewModel) {
        postTitleLabel.text = viewModel.title
        
        if let data = viewModel.imageData {
            postImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageUrl {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data else { return }
                
                viewModel.imageData = data
                
                DispatchQueue.main.async {
                    UIView.transition(with: self?.postImageView ?? UIImageView(), duration: 0.9, options: [.curveEaseOut, .transitionCrossDissolve]) {
                        self?.postImageView.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            postImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            postImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            postImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            postImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            
            postTitleLabel.leadingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: 10),
            postTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            postTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
