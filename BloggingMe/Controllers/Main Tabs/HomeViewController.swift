//
//  ViewController.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private var posts: [BlogPost] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(named: "PrimaryBackground")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let appNameButton: UIButton = {
        let b = UIButton()
        let attributedString = NSMutableAttributedString(string: "BloggingMe", attributes: [.foregroundColor: UIColor.red, .font: UIFont(name: "Cochin Bold Italic", size: 20) as Any])
        b.setAttributedTitle(attributedString, for: .normal)
        b.layer.shadowColor = UIColor(named: "ButtonBackground")?.cgColor
        b.layer.shadowOffset = .init(width: 1, height: 4)
        b.layer.shadowOpacity = 0.5
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "PrimaryBackground")
        navigationController?.navigationBar.tintColor = UIColor(named: "ButtonBackground")
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: appNameButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(didTapCreate))
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllPosts()
        setConstraints()
    }
    
    @objc private func didTapCreate() {
        let vc = CreateNewPostViewController()
        vc.title = "Create Post"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.sheetPresentationController?.prefersGrabberVisible = true
        present(navVC, animated: true)
    }
}


// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    private func fetchAllPosts(){
        DatabaseManager.shared.getAllPosts { [weak self] posts in
            self?.posts = posts.sorted(by: >)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
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
}


// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let vc = ViewPostViewController(post: posts[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width/4
    }
}


// MARK: - Constraints
extension HomeViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
