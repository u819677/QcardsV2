//
//  QuestionsViewV2.swift
//  QcardsV2
//
//  Created by Richard Clark on 21/08/2021.
//

import SwiftUI
import CoreData

struct QuestionsViewV3: View {
    @Environment(\.managedObjectContext) private var viewContext
    let persistenceController = PersistenceController.shared
    
    var topic: Topic?  ///@State not appropriate here. topic is passed in from ContentView, it won't change.

    @State var showQueryEntry: Bool = false
    @StateObject var queryStore: QueryStore ///queryStore is created below in init
    
    init(topic: Topic?) {
        self.topic = topic
        let managedObjectContext = persistenceController.container.viewContext
        let storage = QueryStore(managedObjectContext: managedObjectContext, topic: topic)
        self._queryStore = StateObject(wrappedValue: storage)  
    }
    
  
    var body: some View {
        TableView($queryStore.queries, background: background) {query in
            QuestionView(query: query)
        }
        .navigationTitle("\(self.topic?.topicName ?? "nil")" )
        .navigationBarItems(trailing: Button(action: {
            withAnimation {
                  showQueryEntry = true //new Query added here
            }
        })
        {Text(Image(systemName: "plus"))
            .padding()
            .imageScale(.large)
        })
        .sheet(isPresented: $showQueryEntry){
            QueryEntryView(isPresented: $showQueryEntry, selectedTopic: topic!)
        }
    }
    
    struct QuestionView: View {    ///this is the view used to create each line of the table
        @ObservedObject var query: Query       //not sure why not use @Binding here but it works!
        var body: some View {
            Text("\(query.question)")
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
