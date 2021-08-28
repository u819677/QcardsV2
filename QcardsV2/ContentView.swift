//
//  ContentView.swift
//  QcardsV2
//
//  Created by Richard Clark on 20/07/2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext    //context is only required here to enable .onDelete to work
    @StateObject var topicStore: TopicStore
    @State var optionalTopic: Topic?     ///this topic is either used for topic edit or used as nil to trigger new topic entry mode of topicEntryView
    @State var selectedTopic: Topic?    ///this topic is to pass into QuestionsView
    
    @State private var showingAlert = false //this is the alert to warn before topic delete
    @State private var showTopicEntryView: Bool = false //need this for new topic entry
    @State var showQuestionsView: Bool = false     ///the NavLink to QuestionsView needs this Bool because it comes from UITableView triggering the delegate .onSelect function
    
    init(topicStore: TopicStore) {
        _topicStore = StateObject(wrappedValue: topicStore)// I guess it could be created here, but it's created in App.swift so it's all ready to use by this point.
    }
    
    var body: some View {
        NavigationView {
            VStack {    ///this VStack comes from hackingws and seems required because of using EmptyView with the NavLink
                NavigationLink(
                    destination: QuestionsView(topic: selectedTopic),
                    isActive: $showQuestionsView)
                    {EmptyView() }  //ie: the NavLink is attached to an empty view, not the whole view as before. Seems to work, not exactly sure why!
                TableView($topicStore.topics, background: background) { topic in  ///TableView is the UITableView created with much help from Paris Pinkney.
                    TopicView(topic: topic)
                }
                
                //MARK:- onSelect and onDelete
                .onSelect {topic in
                    self.showQuestionsView = true   ///this triggers the NavLink to QuestionsView
                    self.selectedTopic = topic
                }
                .onDelete { index in    /// no variable  is required for this topic , due .onDelete uses just the index.  Need to ensure cascade delete works here to delete all associated queries.
                    showingAlert = true ///this is the warning to ask user to confirm delete. Control flow gets rather complex here. See TableView delegate functions.
                    let topicToDelete = topicStore.topics[index]
                    topicStore.topics.remove(at: index)
                    viewContext.delete(topicToDelete)
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
                .onMore {topic in   //.onMore really means .onEdit
                    optionalTopic = topic
                }
                .sheet(item: $optionalTopic) { item in    ///edit View animation triggered when optionalTopic is not nil.
                    withAnimation {
                        TopicEntryView(topic: item)
                    }
                }
            }   //  end of VStack
            

            //MARK:- Navigation Bar
            .navigationBarItems(trailing: Button(action: {
                withAnimation {
                    showTopicEntryView = true
                }
            })
            {Text(Image(systemName: "plus"))
                .padding()
                .imageScale(.large)
            })
            .navigationTitle("Topics")  //this is immediately before end of NavView to display properly on child view. makes sense!
            // .navigationBarTitle("Topics") //seems that this is deprecated
            
        } //END OF NAVIGATION VIEW
        
        .preferredColorScheme(.dark)  //this drives the child view to be .dark also, but need this to make Table header black
        .navigationViewStyle(StackNavigationViewStyle())   //this stops iPad split screen behaviour, which works as it should but not sure it's ideal.
        .sheet(isPresented: $showTopicEntryView)  {
       // .sheet(isPresented: $optionalTopic == nil ? true : false)  {///tried this, which would avoid using a Bool,  but the compiler complains:  Result values in '? :' expression have mismatching types 'Bool' and 'Bool'
             TopicEntryView(topic: optionalTopic)
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
        @ObservedObject var topic: Topic
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
