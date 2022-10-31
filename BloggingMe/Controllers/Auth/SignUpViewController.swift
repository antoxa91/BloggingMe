//
//  SignUpViewController.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    private let headerView = SignInHeaderView()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Full Name"
        field.setupLeftImage(imageViewNamed: "person")
        field.backgroundColor = .secondarySystemBackground
        field.borderStyle = .roundedRect
        field.clearButtonMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.setupLeftImage(imageViewNamed: "envelope")
        field.placeholder = "Email Address"
        field.backgroundColor = .secondarySystemBackground
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let createPasswordField: UITextField = {
        let field = UITextField()
        field.setupLeftImage(imageViewNamed: "key")
        field.placeholder = "Create Password"
        field.isSecureTextEntry = true
        field.backgroundColor = .secondarySystemBackground
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let confirmPasswordField: UITextField = {
        let field = UITextField()
        field.setupLeftImage(imageViewNamed: "key")
        field.placeholder = "Confirm Password"
        field.isSecureTextEntry = true
        field.backgroundColor = .secondarySystemBackground
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.title = "Create Account"
        button.configuration?.baseBackgroundColor = .systemGreen
        button.configuration?.baseForegroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = UIColor(named: "PrimaryBackground")
        setupViews()
        setConstraints()
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    private func setupViews() {
        view.addSubview(headerView)
        stackView = UIStackView(arrangedSubviews: [nameField, emailField, createPasswordField, confirmPasswordField, signUpButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = view.frame.size.height * 0.01
        view.addSubview(stackView)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func didTapSignUp() {
        guard let email = emailField.text, !email.isEmpty,
              let password = createPasswordField.text, !password.isEmpty, createPasswordField.text == confirmPasswordField.text,
              let name = nameField.text, !name.isEmpty else {
            signUpButton.animateError()
            return
        }
        //create user
        AuthManager.shared.singUp(email: email, password: password) { [weak self] success in
            if success {
                // Update database
                let newUser = User(name: name, email: email, profilePictureRef: nil)
                DatabaseManager.shared.insertUser(newUser) { inserted in
                    guard inserted else {
                        return
                    }
                    
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(name, forKey: "name")
                    
                    DispatchQueue.main.async {
                        let vc = TabBarController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true)
                    }
                }
            } else {
                let ac = UIAlertController(title: "Failed to create account", message: "Try again", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .destructive))
                self?.present(ac, animated: true)
            }
        }
    }
}


// MARK: - Constraints
extension SignUpViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.56),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
}
