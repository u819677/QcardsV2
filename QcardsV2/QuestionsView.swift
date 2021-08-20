//
//  QuestionsView.swift
//  QcardsV2
//
//  Created by Richard Clark on 12/08/2021.
//

import SwiftUI

struct QuestionsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var queries: [Query] // = []   //if make this optional then have a problem with TableView because it's no longer a random access collection it seems...
    var topic: Topic?   //@State didn't work here!
    
    init(topic: Topic?) {   //can avoid also passing in queryArray, can access all the queries from the topic here in QuestionsView
        self.topic = topic
        self.queries = topic?.queryArray ?? []
    }
    
    var body: some View {
        TableView($queries, background: background) {query in
            QuestionView(query: query)
        }
        .navigationTitle("\(self.topic?.topicName ?? "nil")" )
        
        
        
        .navigationBarItems(trailing: Button(action: {
            withAnimation {
                // showTopicEntryView = true //need to trigger QueryEntryView here
                print("+button tapped")
                print(topic ?? "no topic there")        //not sure why not!
            }
        })
        {Text(Image(systemName: "plus"))
            .padding()
            .imageScale(.large)
        })
    }
    struct QuestionView: View {    //this is the view used to create each line of the table
        @ObservedObject      var query: Query       //not sure why not use @Binding here but it works!
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
