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
    var topic: Topic?
    @StateObject var queryStore: QueryStore
    @State var showQueryEntry: Bool = false
    
    init(topic: Topic?) {
        self.topic = topic
        let managedObjectContext = persistenceController.container.viewContext
        let storage = QueryStore(managedObjectContext: managedObjectContext, topic: topic)
        self._queryStore = StateObject(wrappedValue: storage)   //and bingo, the queryStore of topic relevant queries is ready
    }
    
    var body: some View {
        TableView($queryStore.queries, background: background) {query in
            QuestionView(query: query)
        }
        .navigationTitle("\(self.topic?.topicName ?? "nil")" )
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
            QueryEntryView(isPresented: $showQueryEntry, selectedTopic: topic!) //maybe need to guard here against a blank topic being selected??
        }
    }
    struct QuestionView: View {    //this is the view for each line of the table
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
