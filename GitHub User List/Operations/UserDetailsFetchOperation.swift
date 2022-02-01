//
//  UserDetailsFetchOperation.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 28/01/2022.
//

import Foundation
import CoreData

/// An operation that fetches completes details of the user and save it to the core data.
final class UserDetailsFetchOperation: NetworkOperation {
    
    var error: Error?
    var user: User?
    var username: String
    let context = DataManager.shared.newPrivateContext()
    
    init(username: String) {
        self.username = username
    }
    
    override func main() {
        
        APIClient.request(endPoint: .getUserDetail(username)) { [unowned self] (data: UserDetailData)  in
            
            let parser = UserDetailsParser(data)
            self.user = parser.updateUserDetailsUingContext(context)
            if let user = self.user {
                self.complete(result: .success(user))
            } else {
                self.complete(result: .failure(ApiError.failToParse))
            }
            
        } onFailure: { errorFound in
            self.error = errorFound
        }
    }

}
