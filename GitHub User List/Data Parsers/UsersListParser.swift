//
//  UsersListParser.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 31/01/2022.
//

import CoreData

/// Convers UserData into User and saves in to the core data using a provided managed object context
final class UsersListParser {
    
    let usersData: [UserData]
    
    init(_ usersData: [UserData]) {
        self.usersData = usersData
    }
    
    func saveDataUsingContext(_ context: NSManagedObjectContext) -> [User] {
        var users = [User]()
        for data in usersData {
            if let user = userWithId(data.id, inContext: context) {
                user.login = data.login
                user.id = data.id
                user.avatarURL = data.avatar_url
                users.append(user)
            }
        }
        DataManager.shared.saveContext(context)
        return users
    }
    
    private func userWithId(_ id: Int64, inContext context: NSManagedObjectContext) -> User? {
        let request = User.fetchRequest() as NSFetchRequest<User>
        request.predicate = NSPredicate(format: "id == %i",id)
        
        do {
            let results = try context.fetch(request)
            if let user = results.first {
                return user
            }
            else {
                let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
                let user = User(entity: entity, insertInto: context)
                user.id = id
                return user
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
}
