//
//  ApplicationCoordinator.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 26/01/2022.
//

import UIKit

final class ApplicationCoordinator: Coordinator {
    private let window: UIWindow
    private let rootViewController: UINavigationController
    private let usersListCoordinator: UsersListCoordinator
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        usersListCoordinator = UsersListCoordinator(presenter: rootViewController)
    }
    
    func start() {
        window.rootViewController = rootViewController
        usersListCoordinator.start()
        window.makeKeyAndVisible()
    }
}
