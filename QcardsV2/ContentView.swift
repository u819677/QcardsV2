//
//  ContentView.swift
//  QcardsV2
//
//  Created by Richard Clark on 20/07/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Topic.topicName, ascending: true)],
        animation: .default)
    var fetchedTopics: FetchedResults<Topic> //FetchRequest puts the results into here

    @StateObject var topicStore: TopicStore
    
    @State private var showingPopover = false

    @State var editingTopic: Topic?  //using @State to allow this property to change once the program runs
    @State private var showTopicEntryView: Bool = false
    @State var newTopic: String = ""
    

   
 
    
    var body: some View {

            NavigationView {
            TableView($topicStore.topics, background: background) { topic in  //TableView is a UITableView
                TopicView(topic: topic)
            }
            
            .onSelect { topic in
            }
            .onDelete { index in
                let topicToRemove = topicStore.topics[index]
                topicStore.topics.remove(at: index)
                viewContext.delete(topicToRemove)
                
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
            
            //MARK:- onMore
            .onMore { topic in
                editingTopic = topic
            }
            .sheet(item: $editingTopic) { item in    //animation triggered when optional onMoreTopic is not nil
                withAnimation {
                    TopicEntryView(isPresented: $showTopicEntryView, topic: item)
            }
            }
                
            .navigationBarTitle("Topics")

            .navigationBarItems(trailing: Button(action: {
                withAnimation {
                    showTopicEntryView = true
                }
            })
            {Text(Image(systemName: "plus"))
                .padding()
                .imageScale(.large)
            })
            .preferredColorScheme(.dark)
        } //end of NavView
            .navigationViewStyle(StackNavigationViewStyle())

            .sheet(isPresented: $showTopicEntryView)  {
                TopicEntryView(isPresented:$showTopicEntryView, topic: editingTopic)
            }
        
    }//end of body
    
    //MARK:- addTopic
    private func addTopic() {
        withAnimation {
            let newTopic = Topic(context: viewContext)
            newTopic.topicName = self.newTopic
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    var background: some View {
        //Image(systemName: "sun.haze.fill")
        Image("blackboard")
            .resizable()
            //.aspectRatio(contentMode: .fit)
            .edgesIgnoringSafeArea(.all)
            //.foregroundColor(.orange)
    }
    //MARK:- TopicView
    struct TopicView: View {
     @ObservedObject      var topic: Topic
        var body: some View {
            Text(topic.name)
                //.font(.largeTitle)
                .font(.custom("Noteworthy Bold", size: 30 ))
                .foregroundColor(.white)
                //.foregroundColor(Color.primary) //this makes the text black
        }
    }
    
    
}


///can't get this to work because ContentView needs a topicStore parameter...
//struct ContentView_Previews: PreviewProvider {
//    @StateObject var topicStore: TopicStore
//    static var previews: some View {
//        ContentView(topicStore: topicStore ).environment(\.managedObjectContext,
//                                  PersistenceController.preview.container.viewContext)
//    }
//}
