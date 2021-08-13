//
//  QuestionsView.swift
//  QcardsV2
//
//  Created by Richard Clark on 12/08/2021.
//

import SwiftUI

struct QuestionsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var topic: Topic?
    @StateObject var topicStore: TopicStore
    
 var queries: [Query] {
    let queryList = (topic?.queryArray)!
        return queryList
    }
    
    var background: some View {
        Image("blackboard")
            .resizable()
            .edgesIgnoringSafeArea(.all)
    }
    var body: some View {
     // Text("QuestionsView")
        TableView($topicStore.queries, background: background) {query in
            Text("\(query.question)")
        }
    }
}

//struct QuestionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionsView()
//    }
//}
