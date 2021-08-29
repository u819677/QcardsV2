//
//  QuestionsView.swift
//  QcardsV2
//
//  Created by Richard Clark on 12/08/2021.
//

import SwiftUI
import CoreData

struct QuestionsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    let persistenceController = PersistenceController.shared
    @StateObject var queryStore: QueryStore
    let topic: Topic?   ///this is the inbound selected topic used to create the queries
    @State var optionalQuery: Query?    ///this is a selected query for editing
    @State var showQueryEntry: Bool = false
    @State var showingAlert = false
    
    init(topic: Topic?) {
        self.topic = topic
        let managedObjectContext = persistenceController.container.viewContext
        let storage = QueryStore(managedObjectContext: managedObjectContext, topic: topic)
        self._queryStore = StateObject(wrappedValue: storage)   ///and bingo, the queryStore of all relevant queries is ready
    }
    
    var body: some View {
        TableView($queryStore.queries, background: background) {query in
            QuestionView(query: query)
        }
        .onSelect {query in
            print("\(query) was selected")
        }
        .onDelete { index in    // no topic variable  is required, because .onDelete uses the index
            showingAlert = true ///this is the warning to ask user to confirm delete. Control flow gets rather complex here. See TableView delegate functions.
            let queryToDelete = queryStore.queries[index]
            queryStore.queries.remove(at: index)
            viewContext.delete(queryToDelete)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        .onMore { query in
            print("query to edit is \(query)" )
            optionalQuery = query
        }
        .sheet(item: $optionalQuery) { item in    ///edit View animation triggered when optionalQuery is not nil, ie: in edit mode
            withAnimation {
                QueryEntryView(optionalQuery: item)
            }
        }
        
        .navigationTitle(self.topic?.topicName ?? "nil" )
        .navigationBarItems(trailing: Button(action: {
            withAnimation {
                 showQueryEntry = true
            }
        })
        {Text(Image(systemName: "plus"))
            .padding()
            .imageScale(.large)
        })
        .sheet(isPresented: $showQueryEntry){
            QueryEntryView(selectedTopic: topic!)   ///there will always be an inbound topic so force-unwrap should be safe!
        }
    }
    struct QuestionView: View {    //this is the view used for each line of the Questions table
        @ObservedObject var query: Query       //not sure why not use @Binding here but it works!
        var body: some View {
            Text(query.question)
                .font(.custom("Noteworthy Bold", size: 26 )) //may need to use system font size eg: font(.largeTitle)
                .foregroundColor(.white) //may need to use Color.primary to enable accessibility here.
        }
    }
    
    var background: some View {
        Image("blackboard")
            .resizable()
            .edgesIgnoringSafeArea(.all)
    }
}

//struct QuestionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionsView()
//    }
//}
