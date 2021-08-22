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
//This is a copy of TopicStore pretty much...

class QueryStore: NSObject, ObservableObject {
    @Published var queries: [Query] = []
    private let queriesController: NSFetchedResultsController<Query>
    var topic: Topic?
    let persistenceController = PersistenceController.shared
    @StateObject var queryStore: QueryStore
//    init() {
//        let managedObjectContext = persistenceController.container.viewContext
//        let storage = QueryStore(managedObjectContext: managedObjectContext)
//        self._queryStore = StateObject(wrappedValue: storage)
//    }
    //need to add an optional topic, then pass that in to use as a predicate in the fetch request...
    init( managedObjectContext: NSManagedObjectContext) {
        queriesController = NSFetchedResultsController(fetchRequest: Query.fetchRequest(),
                                                      managedObjectContext: managedObjectContext,
                                                      sectionNameKeyPath: nil,
                                                      cacheName: nil
        )

        let managedObjectContext = persistenceController.container.viewContext
        let storage = QueryStore(managedObjectContext: managedObjectContext)
        self._queryStore = StateObject(wrappedValue: storage)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
       var fetchRequest: NSFetchRequest<Query> {
            let request: NSFetchRequest<Query> = Query.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Query.queryQuestion, ascending: false)]
            return request
        }
     
        
        //PLAN1
        //create a new queryController here which uses a local fetch request
        //create the fetch request using a predicate topic, which is passed in, sort descriptor not needed
        //run the actual perform fetch and assign results to the published var queries
        super.init()
        queriesController.delegate = self

        do {
            try queriesController.performFetch()
            print("queryStore ran queriesController.performFetch()")
            queries = queriesController.fetchedObjects ?? []
        }   catch {
            print("failed to fetch")
        }
        
    }//end of init
    
    
    
}

//not sure if either or both of these are needed
extension QueryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let changedQueries = controller.fetchedObjects as? [Query]
        else { return }
        print("TopicStore ran controllerDidChangeContent")
        queries = changedQueries
    }
}
extension QueryStore {
    func controllerDidChangeObject(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let changedQueries = controller.fetchedObjects as? [Query]
        else { return }
        print("TopicStore ran controllerDidChangeObject")
        queries = changedQueries
    }
}
