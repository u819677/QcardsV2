//
//  Query+CoreDataProperties.swift
//  QcardsV2
//
//  Created by Richard Clark on 20/07/2021.
//
//

import Foundation
import CoreData


extension Query {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Query> {
        return NSFetchRequest<Query>(entityName: "Query")
    }

    @NSManaged public var queryQuestion: String?
    @NSManaged public var answer: String?
    @NSManaged public var extra: String?
    @NSManaged public var id: UUID?
    @NSManaged public var grade: Int16
    @NSManaged public var topic: Topic?
    
    
    public var question: String {   //this is like a wrapper, to enable the optional queryQuestion to be more easily used later.
        queryQuestion ?? "missing queryQuestion"
    }

}

extension Query : Identifiable {
    static var extensionFetchRequest: NSFetchRequest<Query> {
        let request: NSFetchRequest<Query> = Query.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Query.queryQuestion, ascending: false)]
        return request
    }
}
