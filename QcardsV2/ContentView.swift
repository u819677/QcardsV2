//
//  ContentView.swift
//  QcardsV2
//
//  Created by Richard Clark on 20/07/2021.
//

import SwiftUI
import CoreData
import UIKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext    //context is only required here to enable .onDelete to work
    
    @StateObject var topicStore: TopicStore
    @State var editingTopic: Topic?  //using @State to allow this property to change once the program runs
    
    
    
    @State var chosenTopic: Topic?  //has to be optional to avoid requiring this parameter way back up in App.swift
   //@State var chosenTopic: Topic? // = Topic()    //can also use :Topic() = []
    
    
    
    
    @State private var showingAlert = false
    @State private var showTopicEntryView: Bool = false
    @State var isLinking: Bool = false
    @State var queries: [Query] = []
    
    //MARK:-  queryStore
    
    
   // @StateObject var queryStore: QueryStore
    
    
    
    
    let persistenceController = PersistenceController.shared

    init(topicStore: TopicStore) {
        _topicStore = StateObject(wrappedValue: topicStore)
        //now need to init the queryStore. Can't use viewContext from environment due it's not accessible yet
        
        
        //trying to init the queryStore in QuestionsViewV3, so have commented out line 34
//        let managedObjectContext = persistenceController.container.viewContext
//        let storage = QueryStore(managedObjectContext: managedObjectContext)
//        self._queryStore = StateObject(wrappedValue: storage)
        
        
        
        
        //maybe have a @State topic in here to use as a predicate, so every time it changed, this init would be re-run?
    }
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                //this VStack comes from hackingws and seems required because of using EmptyView with the nav link
                
          
                NavigationLink(
                    destination: QuestionsViewV3(topic: chosenTopic),
                    //destination: QuestionsViewV2(topic: chosenTopic, queryStore: queryStore),
                   //destination: QuestionsView(topic: chosenTopic),   //TEMP DISABLE TO TEST QUESTIONSVIEWV2
                    isActive: $isLinking)
                    {EmptyView() }  //ie: the NavLink is attached to an empty view, not the whole view as before. Seems to work, not sure why!
   
                
                
                TableView($topicStore.topics, background: background) { topic in  //TableView is a UITableView
                    TopicView(topic: topic)
                }
                
                //MARK:- onSelect and onDelete
                .onSelect { topic in
                    self.isLinking = true   //this is what triggers the NavLink
                    self.chosenTopic = topic
                    print("onSelect chosenTopic.topicName = \(self.chosenTopic?.topicName ?? "no topicName")")
                }
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
                .sheet(item: $editingTopic) { item in    ///animation triggered when optional editingTopic is not nil. Using another Bool for this could get confusing! Possibly could avoid using the Bool here?
                    withAnimation {
                        TopicEntryView(isPresented: $showTopicEntryView, topic: item)
                    }
                }
                Text("there are \(topicStore.topics.count) topics")
            }   //  end of VStack
            
            
            
            //MARK:- Navigation Bar
            .navigationBarItems(trailing: Button(action: {
                withAnimation {
                    showTopicEntryView = true
                    print("no. of topics = \(topicStore.topics.count)")
                }
            })
            {Text(Image(systemName: "plus"))
                .padding()
                .imageScale(.large)
            })
            .navigationViewStyle(StackNavigationViewStyle())    //this seems to make no difference
            
            .navigationTitle("Topics")  //this needs to be just before end of nav view to display properly on child view
            // .navigationBarTitle("Topics") //seems that this is deprecated
            
        } //END OF NAVIGATION VIEW
        // .navigationTitle("TOPICS")    //doesn't work when it's here
        
        .preferredColorScheme(.dark)  //this drives the child view to be .dark also, but need this to make Table header black
        .navigationViewStyle(StackNavigationViewStyle())   //this stops iPad split screen behaviour
        .sheet(isPresented: $showTopicEntryView)  {
            TopicEntryView(isPresented:$showTopicEntryView, topic: editingTopic)
            
        }
        
    }  //END OF BODY
    
    //MARK:-  background
    var background: some View {
        Image("blackboard")
            .resizable()
            .edgesIgnoringSafeArea(.all)
    }
    //MARK:- TopicView
    struct TopicView: View {    //this is the view used in each line of the table
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
