//
//  ContentView.swift
//  QcardsV2
//
//  Created by Richard Clark on 20/07/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext    //context is only required here to enable .onDelete to work
 
    @StateObject var topicStore: TopicStore
    
    @State private var showingAlert = false
    
    @State var editingTopic: Topic?  //using @State to allow this property to change once the program runs
    @State private var showTopicEntryView: Bool = false
    @State var newTopic: String = ""
    
    
    var body: some View {
        
        NavigationView {
            TableView($topicStore.topics, background: background) { topic in  //TableView is a UITableView
                TopicView(topic: topic)
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            //MARK:- onDelete
            .onSelect { topic in
            }   //this isn't really needed. Have set the highlight row to false, over in TableView
            .onDelete { index in
                showingAlert = true
            
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
            //MARK:- Navigation Bar
            .navigationBarTitle("Topics")
            
            .navigationBarItems(trailing: Button(action: {
                withAnimation {
                    showTopicEntryView = true
                    print("no. of topics = \(topicStore.topics.count)")
                    print("first element of array is \(topicStore.topics[4])")
                }
            })
            {Text(Image(systemName: "plus"))
                .padding()
                .imageScale(.large)
            })
            .preferredColorScheme(.dark)
        } //end of NavView
        
        .navigationViewStyle(StackNavigationViewStyle())   //this stops iPad split screen behaviour
        
        .sheet(isPresented: $showTopicEntryView)  {
            TopicEntryView(isPresented:$showTopicEntryView, topic: editingTopic)
        }
    }//end of body
    
    //MARK:-  background
    var background: some View {
        Image("blackboard")
            .resizable()
            .edgesIgnoringSafeArea(.all)
    }
    //MARK:- TopicView
    struct TopicView: View {
        @ObservedObject      var topic: Topic
        var body: some View {
            Text(topic.name)
                .font(.custom("Noteworthy Bold", size: 30 )) //may need to use system font size eg: font(.largeTitle)
                .foregroundColor(.white) //may need to use Color.primary to enable accessibility here.
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
