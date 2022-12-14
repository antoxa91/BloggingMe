//
//  SignInViewController.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//
import UIKit

final class SignInViewController: UIViewController {
    
    private let headerView = SignInHeaderView()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.setupLeftImage(imageViewNamed: "envelope.fill")
        field.placeholder = "Email Address"
        field.backgroundColor = .secondarySystemBackground
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.setupLeftImage(imageViewNamed: "key.fill")
        field.enablePasswordToggle()
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.backgroundColor = .secondarySystemBackground
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = UIColor(named: "ButtonBackground")
        button.configuration?.title = "Sign in with Email"
        return button
    }()
    
    private lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.configuration = .plain()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = UIColor(named: "PrimaryBackground")
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        setupViews()
        setConstraints()
        setButtonTargets()
    }
    
    private func setupViews() {
        view.addSubview(headerView)
        view.addSubview(stackView)
        view.addSubview(createAccountButton)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(signInButton)
    }
    
    private func setButtonTargets() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
    }
    
    @objc private func didTapSignIn() {
        guard let email = emailField.text, !email.isEmpty, email.isValid(),
              let password = passwordField.text, !password.isEmpty else {
            signInButton.animateError()
            HapticsManager.shared.vibrate(for: .error)
            return
        }
        
        AuthManager.shared.singIn(email: email, password: password) { [weak self] success in
            if success {
                self?.signInButton.configuration?.showsActivityIndicator = true
                self?.signInButton.configuration?.title = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let vc = TabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                    HapticsManager.shared.vibrate(for: .success)
                }
                UserDefaults.standard.set(email, forKey: "email")
            } else {
                HapticsManager.shared.vibrate(for: .error)
                Alert.showErrorAlert(vc: self ?? UIViewController(), message: "The account does not exist or the username & password are entered incorrectly")
            }
        }
    }
    
    @objc private func didTapCreateAccount() {
        let vc = SignUpViewController()
        vc.title = "Create Account"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
}


// MARK: - Constraints
extension SignInViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.22),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            createAccountButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: view.frame.size.height * 0.05),
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            createAccountButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
        ])
    }
}
