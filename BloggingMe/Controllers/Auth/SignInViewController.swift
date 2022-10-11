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
        button.configuration?.title = "Sign in with Email"
        return button
    }()
    
    private lazy var signInWithGoogle: UIButton = {
       let button = UIButton()
        button.configuration = .gray()
        button.configuration?.image = UIImage(named: "google-logo")
        button.configuration?.imagePlacement = .all
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var singInWithApple: UIButton = {
        let button = UIButton()
         button.configuration = .gray()
         button.configuration?.image = UIImage(named: "apple-logo")
         button.configuration?.imagePlacement = .all
         button.translatesAutoresizingMaskIntoConstraints = false
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
        setButtonTargets()
    }
    
    private func setupViews() {
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(signInWithGoogle)
        view.addSubview(singInWithApple)
        view.addSubview(createAccountButton)
    }
    
    private func setButtonTargets() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        signInWithGoogle.addTarget(self, action: #selector(didTapSignInWithGoogle), for: .touchUpInside)
        singInWithApple.addTarget(self, action: #selector(didTapSignInWithApple), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
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
                        
            self?.signInSuccess()
            self?.signInButton.configuration?.showsActivityIndicator = false
            UserDefaults.standard.set(email, forKey: "email")
        }
    }
    
    
    @objc private func didTapSignInWithGoogle() {
        AuthManager.shared.singInWithGoogle(signVC: self) { [weak self] success in
            guard success else { return }
            self?.signInSuccess()
        }
    }
        
    @objc private func didTapSignInWithApple() {
//        let provider = ASAuthorizationAppleIDProvider()
//        let request = provider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let controller = ASAuthorizationController(authorizationRequests: [request])
//
//        controller.delegate = self
//        controller.presentationContextProvider = self
//        controller.performRequests()
    }
    
    private func signInSuccess() {
        DispatchQueue.main.async {
            let vc = TabBarController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    @objc private func didTapCreateAccount() {
        let vc = SignUpViewController()
        vc.title = "Create Account"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

//
//// MARK: - ASAuthorizationControllerDelegate
//extension SignInViewController: ASAuthorizationControllerDelegate {
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print("failed")
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        switch authorization.credential {
//        case let credentials as ASAuthorizationAppleIDCredential:
//            let firstName = credentials.fullName?.givenName
//            let lastName = credentials.fullName?.familyName
//            let email = credentials.email
//            break
//
//        default:
//            break
//        }
//    }
//}
//
//// MARK: - ASAuthorizationControllerPresentationContextProviding
//extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return view.window!
//    }
//}


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

            signInWithGoogle.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            signInWithGoogle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            signInWithGoogle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.46),
            signInWithGoogle.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            
            singInWithApple.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            singInWithApple.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            singInWithApple.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.46),
            singInWithApple.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            
            createAccountButton.topAnchor.constraint(equalTo: singInWithApple.bottomAnchor, constant: view.height * 0.05),
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            createAccountButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),
        ])
    }
}
