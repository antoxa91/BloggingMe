//
//  ProfileViewController.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var user: User?
    private var posts: [BlogPost] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let myHeaderView = ProfileHeaderView()
    
    let currentEmail: String
    
    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(didTapSignOut))
        setupTable()
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupTableHeader()
        fetchProfileData()
        setConstraints()
    }
    
    ///Sign Out
    @objc private func didTapSignOut() {
        let ac = UIAlertController(title: "Sign Out", message: "Are you sure you'd like to sign out?", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            AuthManager.shared.singOut { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "name")
                        
                        let signVC = SignInViewController()
                        signVC.navigationItem.largeTitleDisplayMode = .always
                        
                        let navVC = UINavigationController(rootViewController: signVC)
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true)
                    }
                }
            }
        }))
        present(ac, animated: true)
    }
}


// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ViewPostViewController()
        vc.title = posts[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    
    private func fetchPosts(){
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Blog does not exist"
        return cell
    }
}


// MARK: - TableView Header Settings
extension ProfileViewController {
    private func setupTableHeader(profilePhotoRef: String? = nil, name: String? = nil) {
        tableView.tableHeaderView = myHeaderView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto))
        myHeaderView.profilePhoto.addGestureRecognizer(tap)
        myHeaderView.emailLabel.text = currentEmail

        if name != nil {
            title = name
        }
        
        if let ref = profilePhotoRef {
            StorageManager.shared.downloadURLForProfilePicture(path: ref) { url in
                guard let url = url else { return }
                
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        self.myHeaderView.profilePhoto.image = UIImage(data: data)
                    }
                }.resume()
            }
        }
    }
    
    @objc private func didTapProfilePhoto() {
        //чтобы можно менять фото профиля только у себя
        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
              myEmail == currentEmail else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func fetchProfileData() {
        DatabaseManager.shared.getUser(email: currentEmail) {[weak self] user in
            guard let user = user else { return }
            self?.user = user
            
            DispatchQueue.main.async {
                self?.setupTableHeader(
                    profilePhotoRef: user.profilePictureRef,
                    name: user.name
                )
            }
        }
    }
}


// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else { return }
        
        StorageManager.shared.uploadUserProfilePicture(
            email: currentEmail,
            image: image) { [weak self] success in
                guard let strongSelf = self else { return }
                if success {
                    //update database
                    DatabaseManager.shared.updateProfilePhoto(email: strongSelf.currentEmail) { updated in
                        guard updated else { return }
                        DispatchQueue.main.async {
                            strongSelf.fetchProfileData()
                        }
                    }
                }
            }
    }
}


// MARK: - Constraints
extension ProfileViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            myHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myHeaderView.widthAnchor.constraint(equalTo: view.widthAnchor),
            myHeaderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.30),
            
            tableView.topAnchor.constraint(equalTo: myHeaderView.safeAreaLayoutGuide.topAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
