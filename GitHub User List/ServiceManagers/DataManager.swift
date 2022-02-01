//
//  DataManager.swift
//  GitHub User List
//
//  Created by Hassan Rafique Awan on 27/01/2022.
//

import Foundation
import CoreData

final class DataManager {
    
    static let shared = DataManager()
        
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GitHub_User_List")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    ///Returns the default managed object context of application linked to the main queue.
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    ///Creates and returns a new private managed object context
    func newPrivateContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.parent = mainContext
        return context
    }
  
    ///Saves teh context to the persistent store. 
    func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
