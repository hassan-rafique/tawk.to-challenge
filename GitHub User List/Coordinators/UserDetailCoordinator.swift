//
//  UserDetailCoordinator.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 26/01/2022.
//

import Foundation
import UIKit

final class UserDetailCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private let user: User
    
    init(presenter: UINavigationController,
         user: User) {
        self.user = user
        self.presenter = presenter
    }
    
    func start() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyBoard.instantiateViewController(withIdentifier: UserDetailViewController.storyboardID) as? UserDetailViewController else {
            return
        }
        controller.user = user
        presenter.pushViewController(controller, animated: true)
    }
}
