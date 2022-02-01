//
//  UsersListCoordinator.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 26/01/2022.
//

import UIKit

final class UsersListCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        let usersListViewController = UsersListViewController()
        usersListViewController.title = "Users list"
        usersListViewController.delegate = self
        presenter.pushViewController(usersListViewController, animated: true)
    }
}


// MARK: - UsersListViewControllerDelegate
extension UsersListCoordinator: UsersListViewControllerDelegate {
    
    func userListViewControllerDidSelectUser(_ user: User) {
        let userDetailCoordinator = UserDetailCoordinator(presenter: presenter, user: user)
        userDetailCoordinator.start()
    }
}
