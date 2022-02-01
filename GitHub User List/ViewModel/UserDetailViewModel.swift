//
//  UserDetailViewModel.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 27/01/2022.
//

import Foundation
import CoreData

protocol UserDetailViewModelDelegates: AnyObject {
    func didFinishUpdatingUserData(_ user: User)
    func didStartUpdatingUserData(_ user: User)
    func userDataUpdateFailed(_ error: Error)
    func noteSaved(_ user: User)
    func networkConnectivityFailed()
}

final class UserDetailViewModel {
    
    var user: User

    
    init(user: User, delegate: UserDetailViewModelDelegates? = nil) {
        self.user = user
        self.delegate = delegate
    }
    
    private weak var delegate: UserDetailViewModelDelegates?
    
    private var loadingData = false
    
    func addNote(_ note: String?) {
        self.user.note = note
        DataManager.shared.saveContext(DataManager.shared.mainContext)
        self.delegate?.noteSaved(user)
    }
    
    func updateUserData() {
        guard loadingData == false, let username = user.login else { return }
        if !Reachability.isConnectedToNetwork() {
            self.delegate?.networkConnectivityFailed()
        }
        
        loadingData = true
        self.delegate?.didStartUpdatingUserData(user)
        
        let operation = UserDetailsFetchOperation(username: username)
        operation.name = username
        operation.completionHandler = { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.loadingData = false
                    if let user = self?.user {
                        self?.delegate?.didFinishUpdatingUserData(user)
                    }
                }
                
            case .failure(let error):
                print("image download error:\(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.loadingData = false
                    self?.delegate?.userDataUpdateFailed(error)
                }
            }
        }
        
        DispatchQueue.global().async  {
            
            // avoid adding same operation again
            if !QueueManager.shared.queue.operations.contains(where: {$0.name == self.user.login}) {
                QueueManager.shared.addOperations([operation])
            }
        }

    }

}
