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
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "photo")
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.backgroundColor = .tertiarySystemBackground
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var selectedHeaderImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViews()
        configureButtons()
        setConstraints()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        headerImageView.addGestureRecognizer(tap)
    }
    
    private func setupViews() {
        view.addSubview(headerImageView)
        view.addSubview(textView)
        view.addSubview(titleField)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.font = .systemFont(ofSize: view.width/15)
    }
    
    @objc private func didTapHeader() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true)
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
        
        let newPostId = UUID().uuidString
        
        StorageManager.shared.uploadBlogHeaderImage(email: email, image: headerImage, postId: newPostId) { success in
            guard success else { return }
            
            StorageManager.shared.downloadURLForPostHeader(email: email, postId: newPostId) { url in
                guard let headerURL = url else {
                    print("Failed to upload url for header")
                    return
                }
                
                //insert of post into Database
                let post = BlogPost(identifier: newPostId, title: title, timestamp: Date().timeIntervalSince1970, headerImageUrl: headerURL, text: body)
                
                DatabaseManager.shared.insertPost(blogPost: post, email: email) { [weak self] posted in
                    guard posted else {
                        print("Failed to post new Blog Article")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self?.didTapCancel()
                    }
                }
            }
        }
    }
}


extension CreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        selectedHeaderImage = image
        headerImageView.image = image
    }
}


// MARK: - Constraints
extension CreateNewPostViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            titleField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            
            headerImageView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 10),
            headerImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            headerImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),

            
            textView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
