//
//  UserDetailsParser.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 01/02/2022.
//

import Foundation
import CoreData

/// Update the User object with the details provided in UserDetailsData.
final class UserDetailsParser {
    
    let userDetails: UserDetailData
    
    init(_ userDetails: UserDetailData) {
        self.userDetails = userDetails
    }
    
    func updateUserDetailsUingContext(_ context: NSManagedObjectContext) -> User? {

        if let user = userInContext(context) {
            user.name = userDetails.name
            user.followers = userDetails.followers
            user.following = userDetails.following
            user.seen = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            user.updatedAt = dateFormatter.date(from: userDetails.updated_at)
            user.createdAt = dateFormatter.date(from: userDetails.created_at)
            DataManager.shared.saveContext(context)
            return user
        }
        return nil
    }
    
    private func userInContext(_ context: NSManagedObjectContext) -> User? {
        let request = User.fetchRequest() as NSFetchRequest<User>
        request.predicate = NSPredicate(format: "login == %@",userDetails.login)
        
        do {
            let results = try context.fetch(request)
            if let user = results.first {
                return user
            }
            else {
                let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
                let user = User(entity: entity, insertInto: context)
                user.login = userDetails.login
                return user
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
}
