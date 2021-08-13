//
//  TopicStore.swift
//  Qcards
//
//  Created by Richard Clark on 30/05/2021.
//

import Foundation
import CoreData
import SwiftUI

///folowing is added from Donny Waals "fetching objects from core data in swiftUI."
class TopicStore: NSObject, ObservableObject {
    @Published var topics: [Topic] = []
    private let topicsController: NSFetchedResultsController<Topic>
    @Published var queries: [Query] = []

    
    //need to add an optional topic, then pass that in to use as a predicate in the fetch request...
    init( managedObjectContext: NSManagedObjectContext) {
        topicsController = NSFetchedResultsController(fetchRequest: Topic.extensionFetchRequest,
                                                      managedObjectContext: managedObjectContext,
                                                      sectionNameKeyPath: nil,
                                                      cacheName: nil
        )

        //PLAN
        //create a new queryController here which uses a local fetch request
        //create the fetch request using a predicate topic, which is passed in, sort descriptor not needed
        //run the actual perform fetch and assign results to the published var queries
        super.init()
        topicsController.delegate = self

        
        
        do {
            try topicsController.performFetch()
            print("TopicStore ran topicsController.performFetch()")
            topics = topicsController.fetchedObjects ?? []
        }   catch {
            print("failed to fetch")
        }
        
    }
    
    
    
}

//not sure if either or both of these are needed
extension TopicStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let changedTopics = controller.fetchedObjects as? [Topic]
        else { return }
        print("TopicStore ran controllerDidChangeContent")
        topics = changedTopics
    }
}
extension TopicStore {
    func controllerDidChangeObject(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let changedTopics = controller.fetchedObjects as? [Topic]
        else { return }
        print("TopicStore ran controllerDidChangeObject")
        topics = changedTopics
    }
}
