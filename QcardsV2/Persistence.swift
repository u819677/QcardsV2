//
//  Persistence.swift
//  Qcards
//
//  Created by Richard Clark on 29/05/2021.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<5 {
            let newTopic = Topic(context: viewContext)
            newTopic.topicName = "TEST TOPIC"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "QcardsV2")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            ///add by RDC from Apple developer
            let description = container.persistentStoreDescriptions.first
            description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            ///added also by RDC
            let remoteChangeKey = "NSPersistentStoreRemoteChangeNotificationOptionKey"
            description?.setOption(true as NSNumber, forKey: remoteChangeKey)
            
        }
       // container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy//needed to enable constraints to work correctly ie: only one entity created for a given topicName. Note that there is another option here, PropertyObject, where existing entity trumps new one. Both seem fine here.
        //container.viewContext.automaticallyMergesChangesFromParent = true //RDC
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            print("persistent stores were loaded and merge policies set here")
           
        })
         container.viewContext.automaticallyMergesChangesFromParent = true //RDC
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(NSFetchRequest),
//                                               name: NSNotification.Name(rawValue: "NSPersistentStoreRemoteChangeNotification"),
//                                               object: container.persistentStoreCoordinator)
    }
}
