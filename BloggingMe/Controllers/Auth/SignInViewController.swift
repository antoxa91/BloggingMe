//
//  SignInViewController.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import UIKit

class SignInViewController: UIViewController {
    
    private let headerView = SignInHeaderView()

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
    
    private lazy var signInButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.configuration?.title = "Sign in"
        return button
    }()

    private lazy var createAccountButton: UIButton = {
       let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.configuration = .plain()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        
        setupViews()
        setConstraints()
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(createAccountButton)
    }
    
    @objc private func didTapSignIn() {
        
        ///Todo - проработать 
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            return
        }
        
        signInButton.configuration?.showsActivityIndicator = true
        signInButton.configuration?.title = ""
        
        AuthManager.shared.singIn(email: email, password: password) { [weak self] success in
            
            guard success else { return }
            
            
            
            DispatchQueue.main.async {
                UserDefaults.standard.set(email, forKey: "email")
                let vc = TabBarController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
                self?.signInButton.configuration?.showsActivityIndicator = false
            }
        }
    }
    
    @objc private func didTapCreateAccount() {
        let vc = SignUpViewController()
        vc.title = "Create Account"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - Constraints
extension SignInViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            emailField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 10),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            passwordField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),

            signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            signInButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),

            createAccountButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: view.height * 0.05),
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            createAccountButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),

        ])
    }
}
