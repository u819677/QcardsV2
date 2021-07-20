//
//  TopicEditView.swift
//  Qcards
//
//  Created by Richard Clark on 07/06/2021.
//

import SwiftUI
import CoreData
import CoreData


struct TopicEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentionMode
    var topic: Topic
    @State var revisedTopicName: String = ""
    //@StateObject var topicStore: TopicStore
    var body: some View {
        
        Text("The topic's name is \(topic.name)")
        TextField("new topic name", text: $revisedTopicName)
        Button("Tap to re-name topic") {
            topic.setValue(revisedTopicName, forKey: "topicName")
            
            do {
                try viewContext.save()
                print("saveContext ran")
                
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            presentionMode.wrappedValue.dismiss()
            //print("revisedTopicName = \(revisedTopicName)")
        }
    }
}

