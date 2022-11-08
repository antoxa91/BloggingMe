//
//  RateAppView.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 08.11.2022.
//

import UIKit

final class RateAppVC: UIViewController {
    
    private var selectedRate = 0
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 70
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var starsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        let tap = UITapGestureRecognizer(target: self, action: #selector(didSelectRate))
        stackView.addGestureRecognizer(tap)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Rate Our App"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.9122007489, green: 0.1854611635, blue: 0.3689095974, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sendButton: UIButton = {
       let button = UIButton()
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = UIColor(named: "ButtonBackground")
        button.configuration?.title = "Send"
        button.addTarget(self, action: #selector(showAlertAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.8078431373, blue: 0.9725490196, alpha: 1)
        createStars()
        setupViews()
        setConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        titleLabel.font = UIFont(name: "OpenSans-Bold", size: view.frame.size.width / 10)
    }
    
    
    // MARK: - User actions
    @objc private func showAlertAction() {
        let ac = UIAlertController(title: "BloggingMe Team", message: "Thank you for your feedback! \n We're trying to get better", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .default))
        present(ac, animated: true)
    }
    
    @objc private func didSelectRate(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: starsContainer)
        let starWidth = starsContainer.bounds.width / CGFloat(5)
        let rate = Int(location.x / starWidth) + 1
        
        if rate != self.selectedRate {
            feedbackGenerator.selectionChanged()
            self.selectedRate = rate
        }
  
        starsContainer.arrangedSubviews.forEach { subviews in
            guard let starImageView = subviews as? UIImageView else {
                return
            }
            starImageView.isHighlighted = starImageView.tag <= rate
        }
    }

    
    // MARK: - Private methods
    private func createStars() {
        for index in 1...5 {
            let star = makeStarIcon()
            star.tag = index
            starsContainer.addArrangedSubview(star)
        }
    }
    
    private func makeStarIcon() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "star"),
                                    highlightedImage: UIImage(named: "star_filled"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    private func setupViews() {
        view.addSubview(container)
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(starsContainer)
        container.addArrangedSubview(sendButton)
    }
}

// MARK: - Constraints
extension RateAppVC {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            starsContainer.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.12),
            
            sendButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.12),
        ])
    }
}
