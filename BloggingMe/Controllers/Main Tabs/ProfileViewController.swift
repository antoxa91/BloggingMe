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
    
    private var changeThemeButton: UIBarButtonItem!
    var isDarkModeOn = true
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        tableView.backgroundColor = UIColor(named: "PrimaryBackground")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
        return refreshControl
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
        view.backgroundColor = UIColor(named: "PrimaryBackground")
        setupNavBar()
        setupTable()
        fetchPosts()
    }
    
    private func setupNavBar() {
        navigationItem.backButtonDisplayMode = .minimal
        changeThemeButton = UIBarButtonItem(image: UIImage(named: "moon"), style: .done, target: self, action: #selector(changeThemeTapped))
        navigationItem.leftBarButtonItem = changeThemeButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), menu: profileSettingsTapped())
    }

    private func setupTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
        setupTableHeader()
        fetchProfileData()
        setConstraints()
    }
    
    @objc private func changeThemeTapped() {
        UIView.transition (with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.overrideUserInterfaceStyle = self.isDarkModeOn ? .dark : .light
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.windows.first?.overrideUserInterfaceStyle = self.overrideUserInterfaceStyle
            self.changeThemeButton.image = self.isDarkModeOn ? UIImage(named: "sun") : UIImage(named: "moon")
            self.isDarkModeOn.toggle()
        })
    }
    
    // MARK: - Profile Settings Tapped
    private func profileSettingsTapped() -> UIMenu {
        let changePhoto = UIAction(title: "Change Photo", image: UIImage(named: "photos")) { [weak self] _ in
            guard let myEmail = UserDefaults.standard.string(forKey: "email"),
                  myEmail == self?.currentEmail else { return }
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }
        
        let changeName = UIAction(title: "Change Name", image: UIImage(named: "pencil")) { [weak self] _ in
            let ac = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
            ac.addTextField() { tf in
                tf.placeholder = "Enter New Name"
                tf.setupLeftImage(imageViewNamed: "person")
            }
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "OK", style: .default) {_ in
                guard let tf = ac.textFields else { return }
                guard let newName = tf[0].text, !newName.isEmpty, newName != self?.title else {
                    return
                }
                
                guard let currentEmail = self?.currentEmail else { return }
                DatabaseManager.shared.updateProfileName(email: currentEmail, newName: newName) { success in
                    guard success else { return }
                }
                self?.title = newName
            })
            self?.present(ac, animated: true)
            UserDefaults.standard.set(self?.user?.name, forKey: "name")
        }
        
        let signOut = UIAction(title: "Sign Out", image: UIImage(named: "signOut")) { [weak self] _ in
                let ac = UIAlertController(title: "Sign Out", message: "Are you sure you'd like to sign out?", preferredStyle: .actionSheet)
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                ac.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
                    AuthManager.shared.signOut { [weak self] success in
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
                self?.present(ac, animated: true)
            }
        
        let menu = UIMenu(title: "Settings", image: nil, children: [changePhoto, changeName, signOut])
        return menu
    }
}


// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let vc = DetailPostVC(post: posts[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width/5
    }
}


// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    @objc private func fetchPosts() {
        DatabaseManager.shared.getUserPosts(for: currentEmail) {[weak self] posts in
            self?.posts = posts.sorted(by: >)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else { return UITableViewCell() }
        cell.configure(with: .init(title: post.title, imageUrl: post.headerImageUrl))
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Total Posts: \(posts.count)"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let postId = posts[indexPath.row].identifier
            tableView.beginUpdates()
            
            DatabaseManager.shared.deletePost(email: currentEmail, postId: postId, blogPost: posts[indexPath.row]) { success in
                guard success else { return }
                self.posts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                DispatchQueue.main.async {
                    HapticsManager.shared.vibrate(for: .success)
                }
            }

            StorageManager.shared.deleteBlogHeaderImage(email: currentEmail, postId: postId) { success in
                guard success else { return }
            }            
            tableView.endUpdates()
        }
    }
}


// MARK: - TableView Header Settings
extension ProfileViewController {
    private func setupTableHeader(profilePhotoRef: String? = nil, name: String? = nil) {
        tableView.tableHeaderView = myHeaderView
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
                        UIView.transition (with: self.myHeaderView.profilePhoto, duration: 0.5, options: [.curveEaseOut, .transitionCrossDissolve], animations: {
                            self.myHeaderView.profilePhoto.image = UIImage(data: data)
                        })
                    }
                }.resume()
            }
        }
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
    private func setConstraints() {
        NSLayoutConstraint.activate([
            myHeaderView.widthAnchor.constraint(equalTo: view.widthAnchor),
            myHeaderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.28),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
