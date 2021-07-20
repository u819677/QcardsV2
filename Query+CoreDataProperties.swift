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

    @NSManaged public var question: String?
    @NSManaged public var answer: String?
    @NSManaged public var extra: String?
    @NSManaged public var id: UUID?
    @NSManaged public var grade: Int16
    @NSManaged public var topic: Topic?

}

extension Query : Identifiable {

}
