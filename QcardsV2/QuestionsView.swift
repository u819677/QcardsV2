//
//  QuestionsView.swift
//  QcardsV2
//
//  Created by Richard Clark on 12/08/2021.
//

import SwiftUI

struct QuestionsView: View {
    @Environment(\.managedObjectContext) private var viewContext
   // @State var topic: Topic?
    //@StateObject var topicStore: TopicStore
    @State var queries: [Query]  = []   //make this optional and it's no longer a random acceess collection it seems...
     //PLAN2 try initializing the queries var instead of computed property, so that can meke it into a @State var instead?
// var queries: [Query] {
//    let queryList = (topic?.queryArray)!
//        return queryList
//    }
    @State var topicName: String
   // init(topic: Topic, _ queries: Binding<[Query]> ) {
    init(queries: [Query], topicName: String) {
    //self.topic = topic
        self.queries = queries
        self.topicName = topicName
        
    }
    
    
    
    
    
    
    
    
    var background: some View {
        Image("blackboard")
            .resizable()
            .edgesIgnoringSafeArea(.all)
    }
    var body: some View {
     // Text("QuestionsView")
        
        TableView($queries, background: background) {query in
            Text("\(query.question)")
        }
        .navigationTitle(topicName)
    }
}

//struct QuestionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionsView()
//    }
//}
