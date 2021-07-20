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
    init( managedObjectContext: NSManagedObjectContext) {
        topicsController = NSFetchedResultsController(fetchRequest: Topic.extensionFetchRequest,
                                                      managedObjectContext: managedObjectContext,
                                                      sectionNameKeyPath: nil,
                                                      cacheName: nil
        )
        super.init()
        topicsController.delegate = self
        
        do {
            try topicsController.performFetch()
            print("TopicStore ran topicsController.performFetch()")
            topics = topicsController.fetchedObjects ?? []
            
            //            let tableView = UITableView()
            //            tableView.reloadData()
        }   catch {
            print("failed to fetch")
        }
    }
    
    
    
}


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
