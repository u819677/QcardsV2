//
//  QueryStore.swift
//  QcardsV2
//
//  Created by Richard Clark on 22/08/2021.
//

import Foundation
import CoreData
import SwiftUI

///folowing is added from Donny Waals "fetching objects from core data in swiftUI."
//This is similar to TopicStore but it takes in a topic? to create a predicate in the fetchRequest

class QueryStore: NSObject, ObservableObject {
    @Published var queries: [Query] = []    //this provides the binding queries in the TableView in QuestionsView
    private let queriesController: NSFetchedResultsController<Query>
    
    var topic: Topic?   //the optional topic comes in here, to use as a predicate in the fetch request created below ...
    init( managedObjectContext: NSManagedObjectContext, topic: Topic?) {
        
        self.topic = topic
        var fetchRequest: NSFetchRequest<Query> {
            let request: NSFetchRequest<Query> = Query.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Query.queryQuestion, ascending: true)]
            if topic != nil {
            request.predicate = NSPredicate(format: "topic == %@", topic!)  ///the predicate is optional, so for the initial init of the class, when topic is nil, it's omitted
            }
            return request
        }

        queriesController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                      managedObjectContext: managedObjectContext,
                                                      sectionNameKeyPath: nil,
                                                      cacheName: nil
        )
       super.init() //this allows use of self
        queriesController.delegate = self //this enables delegate method didRespondToChanges
        do {
            try queriesController.performFetch()
            queries = queriesController.fetchedObjects ?? []
            print("QueryStore ran fetchRequest to give \(queries.count) queries")
        }   catch {
            print("failed to fetch")
        }
        
    }//end of init  
}

//not sure if didChangeObject is needed...
extension QueryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let changedQueries = controller.fetchedObjects as? [Query]
        else { return }
        print("QueryStore ran controllerDidChangeContent")
        queries = changedQueries
    }
}
extension QueryStore {
    func controllerDidChangeObject(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let changedQueries = controller.fetchedObjects as? [Query]
        else { return }
        print("QueryStore ran controllerDidChangeObject")
        queries = changedQueries
    }
}
