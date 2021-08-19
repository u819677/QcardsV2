//
//  QuestionsView.swift
//  QcardsV2
//
//  Created by Richard Clark on 12/08/2021.
//

import SwiftUI

struct QuestionsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var queries: [Query]  = []   //if make this optional then have a problem because it's no longer a random acceess collection it seems...
    @State var topicName: String
    @State var topic: Topic?
   
    
    init(queries: [Query], topicName: String, topic: Topic?) {
        self.queries = queries
        self.topicName = topicName
        self.topic = topic
     print("the topic initialized in QuestionsView is \(topic)") //", the topicName is \(topicName) and queries are \(queries)")
        print("the inbound topic.topicName is \(topic?.topicName ?? "nil")")
    }

    var body: some View {
        TableView($queries, background: background) {query in
            QuestionView(query: query)
        }
        //.navigationTitle(topicName)
        
      // DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        .navigationTitle("\(self.topic?.topicName ?? "nil") OR \(topicName)" )
      //  }
        
        
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
        @ObservedObject      var query: Query       //not sure why not binding here but it works!
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
