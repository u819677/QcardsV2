//
//  Topic+CoreDataProperties.swift
//  QcardsV2
//
//  Created by Richard Clark on 20/07/2021.
//
//

import Foundation
import CoreData


extension Topic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Topic> {
        return NSFetchRequest<Topic>(entityName: "Topic")
    }

    @NSManaged public var topicName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var topicDate: Date?
    @NSManaged public var query: NSSet?
    
    
    public var name: String {
        topicName ?? "missing topic"
    }

}

// MARK: Generated accessors for query
extension Topic {

    @objc(addQueryObject:)
    @NSManaged public func addToQuery(_ value: Query)

    @objc(removeQueryObject:)
    @NSManaged public func removeFromQuery(_ value: Query)

    @objc(addQuery:)
    @NSManaged public func addToQuery(_ values: NSSet)

    @objc(removeQuery:)
    @NSManaged public func removeFromQuery(_ values: NSSet)

}

extension Topic : Identifiable {
    static var extensionFetchRequest: NSFetchRequest<Topic> {
        let request: NSFetchRequest<Topic> = Topic.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Topic.topicName, ascending: false)]
        return request
    }
}
