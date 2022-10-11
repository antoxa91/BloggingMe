//
//  SignUpViewController.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let headerView = SignInHeaderView()

    private let nameField: UITextField = {
       let field = UITextField()
        field.placeholder = "Full Name"
        field.setupLeftImage(imageViewNamed: "person.fill")
        field.backgroundColor = .secondarySystemBackground
        field.borderStyle = .roundedRect
        field.clearButtonMode = .always
        field.layer.masksToBounds = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let emailField: UITextField = {
       let field = UITextField()
        field.keyboardType = .emailAddress
        field.setupLeftImage(imageViewNamed: "envelope.fill")
        field.placeholder = "Email Address"
        field.backgroundColor = .secondarySystemBackground
        field.borderStyle = .roundedRect
        field.clearButtonMode = .always
        field.layer.masksToBounds = true
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let passwordField: UITextField = {
       let field = UITextField()
        field.keyboardType = .emailAddress
        field.setupLeftImage(imageViewNamed: "key.fill")
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.backgroundColor = .secondarySystemBackground
        field.borderStyle = .roundedRect
        field.clearButtonMode = .always
        field.layer.masksToBounds = true
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        
        setupViews()
        setConstraints()
        
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.addSubview(headerView)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
    }
    
    @objc private func didTapSignUp() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let name = nameField.text, !name.isEmpty else {
            return
        }
        
        //create user
        AuthManager.shared.singUp(email: email, password: password) { [weak self] success in
            if success {
                // update database
                let newUser = User(name: name, email: email, profilePictureURL: nil)
                DatabaseManager.shared.insert(user: newUser) { inserted in
                    guard inserted else { return }
                    
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(name, forKey: "name")
                    
                    DispatchQueue.main.async {
                        let vc = TabBarController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true)
                    }
                }
            } else {
                print("Failed to create account")
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
            
            nameField.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            nameField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            
            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 10),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            emailField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 10),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            passwordField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),

            signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            signUpButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06)
        ])
    }
}
