//
//  CreateNewPostViewController.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import UIKit

final class CreateNewPostViewController: UITabBarController {
    
    private let titleField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter Title..."
        field.backgroundColor = .secondarySystemBackground
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .words
        field.autocorrectionType = .yes
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "photo")
        imageView.clipsToBounds = true
        imageView.tintColor = UIColor(named: "ButtonBackground")
        imageView.backgroundColor = UIColor(named: "PrimaryBackground")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.backgroundColor = .tertiarySystemBackground
        textView.text = "Start typing..."
        textView.alpha = 0.4
        textView.layer.cornerRadius = 15
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var selectedHeaderImage: UIImage?
    
    lazy var activityIndicator: UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView()
       activityIndicator.style = .large
       activityIndicator.translatesAutoresizingMaskIntoConstraints = false
       activityIndicator.hidesWhenStopped = true
       activityIndicator.color = .white
       return activityIndicator
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "PrimaryBackground")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "check"), style: .done, target: self, action: #selector(didTapPost))
        textView.delegate = self

        setupViews()
        setConstraints()
        
        headerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupViews() {
        view.addSubview(headerImageView)
        view.addSubview(textView)
        view.addSubview(titleField)
        view.addSubview(activityIndicator)
    }
    
    override func viewDidLayoutSubviews() {
        textView.font = .systemFont(ofSize: view.frame.size.width/16)
    }
    
    @objc private func didTapHeader() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func didTapPost() {
        guard let title = titleField.text,
              let body = textView.text,
              let headerImage = selectedHeaderImage,
              let email = UserDefaults.standard.string(forKey: "email"),
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            let ac = UIAlertController(title: "Enter Post Details", message: "Please enter a title, body, and select a image to cotinue.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(ac, animated: true)
            return
        }
        
        activityIndicator.startAnimating()
        
        let newPostId = UUID().uuidString
        
        StorageManager.shared.uploadBlogHeaderImage(email: email, image: headerImage, postId: newPostId) { success in
            guard success else { return }
            
            StorageManager.shared.downloadURLForPostHeader(email: email, postId: newPostId) { url in
                guard let headerURL = url else {
                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .error)
                    }
                    return
                }
                
                let post = BlogPost(identifier: newPostId, title: title, timestamp: Date().timeIntervalSince1970, headerImageUrl: headerURL, text: body)
                
                DatabaseManager.shared.insertPost(blogPost: post, email: email) { [weak self] posted in
                    guard posted else {
                        DispatchQueue.main.async {
                            HapticsManager.shared.vibrate(for: .error)
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .success)
                        self?.dismiss(animated: true)
                        self?.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}


// MARK: - Adjust For Keyboard
extension CreateNewPostViewController {
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func adjustForKeyboard(notification: NSNotification) {
        if notification.name == UIResponder.keyboardWillShowNotification {
            UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: .calculationModeLinear) { [headerImageView = self.headerImageView] in
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.35) {
                    headerImageView.layer.cornerRadius = 15
                    headerImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    headerImageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true
                }
            }
        } else {
            UIView.animateKeyframes(withDuration: 2, delay: 0, options: .calculationModeLinear) { [headerImageView = self.headerImageView] in
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.35) {
                    headerImageView.layer.cornerRadius = 0
                    headerImageView.transform = .identity
                    headerImageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
                }
            }
        }
    }
}


// MARK: - UIImagePickerControllerDelegate
extension CreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        selectedHeaderImage = image
        headerImageView.image = image
    }
}


// MARK: - UITextViewDelegate
extension CreateNewPostViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.text == "Start typing..." {
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == "Start typing..." {
            textView.text = ""
            textView.alpha = 1
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Start typing..."
            textView.alpha = 0.4
        }
    }
}


// MARK: - Constraints
extension CreateNewPostViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            titleField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            
            headerImageView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 8),
            headerImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            headerImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),

            textView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 8),
            textView.widthAnchor.constraint(equalTo: view.widthAnchor),
            textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -8),
            
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
