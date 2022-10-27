//
//  DetailPostVC.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 06.10.2022.
//

import UIKit
import ShimmerSwift

final class DetailPostVC: UITabBarController {
    
    private let post: BlogPost
    
    init(post: BlogPost) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(PostHeaderTableViewCell.self,
                       forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        table.separatorStyle = .none
        table.bounces = false
        return table
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "BloggingMe", attributes: [.foregroundColor: #colorLiteral(red: 0.01176470588, green: 0.5882352941, blue: 0.8980392157, alpha: 1), .font: UIFont(name: "LobsterTwo-Italic", size: 22) as Any])
        label.attributedText = attributedString
        label.layer.shadowColor = UIColor(named: "ButtonBackground")?.cgColor
        label.layer.shadowOffset = .init(width: 1, height: 4)
        label.layer.shadowOpacity = 0.5
        return label
    }()
    
    private let shimmerView: ShimmeringView = {
        let shimmer = ShimmeringView()
        shimmer.isShimmering = true
        shimmer.shimmerSpeed = 20
        shimmer.shimmerAnimationOpacity = 0.4
        return shimmer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "PrimaryBackground")
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        configureNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.safeAreaLayoutGuide.layoutFrame
        shimmerView.frame = appNameLabel.frame
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share"), style: .done, target: self, action: #selector(sharePostTapped))

        navigationItem.titleView = appNameLabel
        navigationController?.navigationItem.titleView?.addSubview(shimmerView)
        shimmerView.center = appNameLabel.center
        shimmerView.contentView = appNameLabel
    }
    
    @objc private func sharePostTapped() {
        guard let imageUrl = post.headerImageUrl else { return }
        
        if let data = try? Data(contentsOf: imageUrl) {
            let avc = UIActivityViewController(activityItems: [
                UIImage(data: data) as Any], applicationActivities: nil)
            present(avc, animated: true)
        }
    }
}


// MARK: - UITableViewDataSource
extension DetailPostVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont(name: "OpenSans-SemiBold", size: view.frame.size.width/17)
            cell.textLabel?.text = post.title
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostHeaderTableViewCell.identifier, for: indexPath) as? PostHeaderTableViewCell else { return UITableViewCell() }
            cell.configure(with: .init(imageUrl: post.headerImageUrl))
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont(name: "OpenSans-Regular", size: view.frame.size.width/19)
            cell.textLabel?.text = post.text
            return cell
        default:
            fatalError()
        }
    }
}


// MARK: - UITableViewDelegate
extension DetailPostVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return view.frame.size.width * 0.9
        default:
            return UITableView.automaticDimension
        }
    }
}
