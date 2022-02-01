//
//  UserTableViewCell.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 26/01/2022.
//

import UIKit

let UserTableViewCellIdentifier = "UserTableViewCell"
let UserNoteTableViewCellIdentifier = "UserNoteTableViewCell"
let UserInvertedImageTableViewCellIdentifier = "UserInvertedImageTableViewCell"
let UserNoteInvertedImageTableViewCellIdentifier = "UserNoteInvertedImageTableViewCell"

class UserTableViewCell: UITableViewCell {
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private(set) lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private(set) lazy var avatarView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(avatarView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)

        layoutViews()
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 14),
            titleLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor, constant: -10),
            
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
            ])
    }
    
    func configureWithUser(user: User) {
        titleLabel.text = user.login
        subTitleLabel.text =  "ID: \(user.id)"
        if let data = user.avatar {
            avatarView.image = UIImage(data: data)
        } else {
            avatarView.image = UIImage(systemName: "person.circle.fill")
        }
        avatarView.alpha = user.seen ? 0.4:1.0
    }
}

class UserNoteTableViewCell: UserTableViewCell {
    
    private lazy var noteIconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "note.text")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(noteIconView)
        
        layoutViews()
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            
            noteIconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            noteIconView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            noteIconView.widthAnchor.constraint(equalToConstant: 40),
            noteIconView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

}

final class UserInvertedImageTableViewCell: UserTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        avatarView.transform =  avatarView.transform.rotated(by: Double.pi)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class UserNoteInvertedImageTableViewCell: UserNoteTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        avatarView.transform =  avatarView.transform.rotated(by: Double.pi)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
