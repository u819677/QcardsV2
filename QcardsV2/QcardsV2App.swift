//
//  QcardsV2App.swift
//  QcardsV2
//
//  Created by Richard Clark on 20/07/2021.
//

import SwiftUI
import CoreData

@main
//struct QcardsV2App: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
struct QcardsV2App: App {
    let persistenceController = PersistenceController.shared
    @StateObject var topicStore: TopicStore
    init() {
        let managedObjectContext = persistenceController.container.viewContext
        let storage = TopicStore(managedObjectContext: managedObjectContext)
        self._topicStore = StateObject(wrappedValue: storage)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(topicStore: topicStore)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
