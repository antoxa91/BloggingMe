//
//  PayWallViewController.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 07.10.2022.
//

import UIKit

class PayWallViewController: UIViewController {
        
    private let header = PayWallHeaderView()
    
    private let heroView = PayWallDescriptionView()
    
    private let termsView: UITextView = {
       let textView = UITextView()
        textView.isEditable = false
        textView.textAlignment = .center
        textView.textColor = .secondaryLabel
        textView.text = "This is an auto-renewable Subscription. It wil be charged to your Apple account before each pay period. You can cancel anytime by going into your Settings > Subscription. Restore purchases if you previously subscribed."
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var buyButton: UIButton = {
       let button = UIButton()
        button.setTitle("Subscribe", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var restoreButton: UIButton = {
       let button = UIButton()
        button.setTitle("Restore Purchases", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 5)
        button.setTitleColor(.link, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "BloggingMe Premium"
        view.backgroundColor = .systemBackground
        setupViews()
        setUpCloseButton()
        setUpButtons()
        setConstraints()
    }
    
    private func setupViews() {
        view.addSubview(header)
        view.addSubview(termsView)
        view.addSubview(buyButton)
        view.addSubview(restoreButton)
        view.addSubview(heroView)
        
        termsView.font = .systemFont(ofSize: view.frame.width/27)
        restoreButton.titleLabel?.font = .systemFont(ofSize: view.frame.width/20)
        buyButton.titleLabel?.font = .systemFont(ofSize: view.frame.width/20)
    }
    
    private func setUpButtons() {
        buyButton.addTarget(self, action: #selector(didTapSubscribe), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(didTapRestore), for: .touchUpInside)
    }
    
    @objc private func didTapSubscribe() {
        //revenue cat
    }
    
    @objc private func didTapRestore() {
        //revenue cat
    }
    
    private func setUpCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
}

// MARK: - Constraints
extension PayWallViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.widthAnchor.constraint(equalTo: view.widthAnchor),
            header.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.23),

            heroView.topAnchor.constraint(equalTo: header.bottomAnchor),
            heroView.widthAnchor.constraint(equalTo: view.widthAnchor),
            heroView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
            
            buyButton.topAnchor.constraint(equalTo: heroView.bottomAnchor, constant: 10),
            buyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            buyButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.13),
            
            restoreButton.topAnchor.constraint(equalTo: buyButton.bottomAnchor, constant: view.frame.height/50),
            restoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restoreButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            restoreButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.13),
            
            termsView.topAnchor.constraint(equalTo: restoreButton.bottomAnchor, constant: 10),
            termsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            termsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            termsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
