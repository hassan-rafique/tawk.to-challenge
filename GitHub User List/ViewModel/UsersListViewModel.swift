//
//  UsersListViewModel.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 26/01/2022.
//

import Foundation
import CoreData

protocol UsersListViewModelDelegate: AnyObject {
    func startedLoadingPageSince(_ userID: Int64)
    func finishedLoadingPageSince(_ userID: Int64)
    func failedToFetchNewUsersSince( _ userID: Int64, error: String)
    func networkConnectivityFailed()
}

final class UsersListViewModel {
    
    weak var delegate: UsersListViewModelDelegate?

    private(set) lazy var fetchedRC: NSFetchedResultsController<User> = {
        let request = User.fetchRequest() as NSFetchRequest<User>
        let primarySortDescriptor = NSSortDescriptor(keyPath: \User.id, ascending: true)
        request.sortDescriptors = [primarySortDescriptor]
        let resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return resultsController
    }()
    
    private var lastUserId: Int64 = 0
    
    private var lastFetchOperationName: String {
        return "UsersSince=(\(lastUserId)"
    }
    
    private let mainManagedObjectContext = DataManager.shared.mainContext

    func performFetch() {
        performLocalFetch()
        loadNextPage()
    }
    
    func loadNextPageIfRequiredAtIndex(_ indexPath: IndexPath) {
        let user = fetchedRC.object(at: indexPath)
        if user.id == lastUserId {
            loadNextPage()
        } 
    }
    
    private func loadNextPage() {
        guard QueueManager.shared.containsOperation(lastFetchOperationName) == false else {
            return
        }
        
        if !Reachability.isConnectedToNetwork() {
            self.delegate?.networkConnectivityFailed()
        }
        
        let operation = UserListRetrievalOperation(index: self.lastUserId)
        operation.name = lastFetchOperationName
        
        operation.completionHandler = { [weak self] result in
            
            guard let strongSelf = self else { return }
            switch result {
            case .success(let users):
                if let users = users as? [User] {
                    DispatchQueue.main.async {
                        strongSelf.delegate?.finishedLoadingPageSince(strongSelf.lastUserId)
                        if let id = users.last?.id {
                            strongSelf.lastUserId = id
                        }
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.delegate?.failedToFetchNewUsersSince(strongSelf.lastUserId, error: error.localizedDescription)
                }
            }
        }
        
        self.delegate?.startedLoadingPageSince(lastUserId)
        DispatchQueue.global().async  {
            if !QueueManager.shared.containsOperation(self.lastFetchOperationName) {
                QueueManager.shared.addOperations([operation])
            }
        }
        
    }
    
    func cellIdentifierForRowAtIndexPath(_ indexPath: IndexPath) -> String {
        let user = fetchedRC.object(at: indexPath)
        if (indexPath.row + 1) % 4 == 0 {
            return user.note == nil ? UserInvertedImageTableViewCellIdentifier : UserNoteInvertedImageTableViewCellIdentifier
        } else {
            return user.note == nil ? UserTableViewCellIdentifier : UserNoteTableViewCellIdentifier
        }
    }
    
    func searchText(_ query: String?) {
        if let query = query, query.count > 0 {
            fetchedRC.fetchRequest.predicate = NSPredicate(format: "login CONTAINS[cd] %@ OR note CONTAINS[cd] %@", query, query)
        } else {
            fetchedRC.fetchRequest.predicate = nil
        }
        performLocalFetch()
    }
    
    func downloadUserAvatar(_ user: User) {
        DispatchQueue.global().async  {
            let operation = ImageDownloadOperation(user: user)
            operation.name = user.avatarURL
            
            // avoid adding same operation again
            if !QueueManager.shared.queue.operations.contains(where: {$0.name == user.avatarURL}) {
                QueueManager.shared.addOperations([operation])
            }
        }
    }
    
    private func performLocalFetch() {
        do {
            try fetchedRC.performFetch()            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

