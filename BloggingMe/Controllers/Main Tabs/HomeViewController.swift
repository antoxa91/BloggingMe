//
//  ViewController.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import UIKit
import ShimmerSwift

final class HomeViewController: UIViewController {
    
    private var posts: [BlogPost] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "PrimaryBackground")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchAllPosts), for: .valueChanged)
        return refreshControl
    }()
        
    private let appNameButton: UIButton = {
        let b = UIButton()
        let attributedString = NSMutableAttributedString(string: "BloggingMe", attributes: [.foregroundColor: #colorLiteral(red: 0.01176470588, green: 0.5882352941, blue: 0.8980392157, alpha: 1), .font: UIFont(name: "LobsterTwo-Italic", size: 22) as Any])
        b.setAttributedTitle(attributedString, for: .normal)
        b.layer.shadowColor = UIColor(named: "ButtonBackground")?.cgColor
        b.layer.shadowOffset = .init(width: 1, height: 4)
        b.layer.shadowOpacity = 0.5
        return b
    }()
    
    private let shimmerView: ShimmeringView = {
        let shimmer = ShimmeringView()
        shimmer.isShimmering = true
        shimmer.shimmerSpeed = 20
        shimmer.shimmerAnimationOpacity = 0.4
        shimmer.translatesAutoresizingMaskIntoConstraints = false
        return shimmer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "PrimaryBackground")
        view.addSubview(tableView)
        configureNavBar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
        fetchAllPosts()
        setConstraints()
        animateTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTableView()
    }

    private func configureNavBar() {
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "note"), style: .done, target: self, action: #selector(didTapCreate))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: appNameButton)
        
        navigationController?.navigationBar.addSubview(shimmerView)
        shimmerView.center = appNameButton.center
        shimmerView.contentView = appNameButton
    }
    
    @objc private func didTapCreate() {
        let vc = CreateNewPostViewController()
        vc.title = "Create Post"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.sheetPresentationController?.prefersGrabberVisible = true
        present(navVC, animated: true)
    }
    
    private func animateTableView() {
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.height
        var delay = 0.0

        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)

            UIView.animate(withDuration: 1.5,
                           delay: delay * 0.1,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                cell.transform = CGAffineTransform.identity
            })
            delay += 1
        }
    }
}


// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    @objc private func fetchAllPosts(){
        DatabaseManager.shared.getAllPosts { [weak self] posts in
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
}


// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let vc = DetailPostVC(post: posts[indexPath.row])
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            shimmerView.widthAnchor.constraint(equalTo: appNameButton.widthAnchor),
            shimmerView.heightAnchor.constraint(equalTo: appNameButton.heightAnchor)
        ])
    }
}
