//
//  UserListRetrievalOperation.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 28/01/2022.
//

import Foundation
import CoreData

/// An operation that downloads users list with pagination support. 
final class UserListRetrievalOperation: NetworkOperation {
    var error: Error?
    var index: Int64
    var users: [User]?
    private var retry: Int = 0

    /// Initialize the User list fetch operation
    /// - Parameter index: Integer ID of the last user loaded.
    init(index: Int64) {
        self.index = index
    }
    
    override func main() {
            APIClient.request(endPoint: .getUsersList(index)) { [unowned self] (usersData: [UserData])  in
                let parser = UsersListParser(usersData)
                let coreDataUsers = parser.saveDataUsingContext(DataManager.shared.newPrivateContext())
                self.users = coreDataUsers
                self.complete(result: .success(coreDataUsers))
            
        } onFailure: { errorFound in
            self.error = errorFound
            self.complete(result: .failure(errorFound))
        }
    }
}
