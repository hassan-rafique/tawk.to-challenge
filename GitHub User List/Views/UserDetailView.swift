//
//  UserDetailView.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 27/01/2022.
//

import UIKit

class UserDetailView: UIView {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var skeletonView: UIView!
    @IBOutlet weak var skeletonImageView: UIImageView!
    @IBOutlet var skeletonLabels: [UILabel]!
    
    weak var controller: UIViewController?
    
    var navigationBarImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width/2
        navigationBarImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        navigationBarImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        skeletonImageView.layer.cornerRadius = skeletonImageView.frame.width/2
        skeletonLabels.forEach{$0.layer.cornerRadius = 11}
    }

    func setUserDetails(_ user: User) {
        if let data = user.avatar {
            avatarImageView.image = UIImage(data: data)
        } else {
            avatarImageView.image = UIImage(systemName: "person.circle.fill")
        }
        
        navigationBarImageView.image = avatarImageView.image
        controller?.navigationItem.titleView = navigationBarImageView
        followersLabel.text = "Followers: \(user.followers)"
        followingLabel.text = "Following: \(user.following)"
        nameLabel.text = "Name: \(user.name ?? "_ _")"
        companyLabel.text = "Company: \(user.company ?? "_ _")"
        blogLabel.text = "Blog: \(user.blog ?? "_ _")"
        noteLabel.text = user.note ??  "Write a note..."
    }

    func showSkeletonView(_ show: Bool) {
        skeletonView.isHidden = !show
    }
    
    func hideContentView(_ hidden: Bool) {
        scrollView.isHidden = hidden
    }
    
}
