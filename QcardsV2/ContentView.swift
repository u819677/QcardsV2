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
    
    //@ObservedObject var topicStore: TopicStore //this is from Donny Waals tutorial
    //@StateObject var topicStore: TopicStore //this is from Paris
    @StateObject var topicStore: TopicStore
    
    @State private var showingActionSheet = false
    @State private var showingPopover = false
    @State private var showingMoreSheet = false
    @State var onMoreTopic: Topic?  //using @State to allow this property to change once the program runs
    @State private var showTopicEntryView: Bool = false
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Topic.topicName, ascending: true)],
        animation: .default)
    var fetchedTopics: FetchedResults<Topic>
    //var topics: FetchedResults<Topic>
    //@StateObject private var store = TopicStore()

    @State var newTopic: String = ""
   
//
 //   init(topicStore: State<TopicStore> ){
//
//        UITableView.appearance().backgroundColor = .clear
//        UITableViewCell.appearance().backgroundColor = .clear
//
//        let navBarApp = UINavigationBarAppearance()

//
//        _topicStore = topicStore
 //   }
    
    
    var body: some View {
        //VStack {
            
//            HStack {
//                Button(action: {
//
//                } ){
//                    Text ("run func")}
//                Spacer()
//                Button(action: {
//                    addTopic()
//                    //self.isPresented = false
//                } ){
//                    Text ("Save")}
//            }
//
            
//            TextField("enter new Topic", text: $newTopic)
//
//                .padding(.horizontal, 20)
//                .padding()
            
            //        List {
            //            ForEach(fetchedTopics,  id: \.self) {topic in
            //                //Text(topic.wrappedTopicName)
            //                Text(topic.name)
            //            }
            //        }
            //
            
            
            NavigationView {
            TableView($topicStore.topics, background: background) { topic in   //was Color.green
                TopicView(topic: topic)
//                    .contextMenu {
//                        Button { print("button tapped")    }
//                            label: {Label("Choose button",systemImage: "globe")}
//                    }   ///above code indent is in my own style to make more compact.  This context menu does work, plus it would have access to topic...
                
            }
            
            .onSelect { topic in
                print("ContentView .onSelect ran for topicName \(topic.name)")
                
                
            }
            .onDelete { index in
                //print(".onDelete topic index  is \(index)")
                //topicStore
                let topicToRemove = topicStore.topics[index]
                print("ContentView .onDelete ran with topicName \(topicToRemove.name)")
                
                print("ContentView .onDelete removing topic index \(index) from topicStore")
                topicStore.topics.remove(at: index)
                //viewContext.delete(topicStore.topics[index])
                
                print("ContentView now deleting topicName \(topicToRemove.name) from CoreData")
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
                print(".onMore topic name  is \(topic.name)")
                onMoreTopic = topic
              
                print("onMoreTopic is now \(onMoreTopic?.name ?? "nil")")
                //showTopicEntryView = true
                //showingMoreSheet = true
                //showingActionSheet = true
                //showingPopover = true
                if UIDevice.current.userInterfaceIdiom == .pad {
                    print("iPad device")
                } else {
                    print("not iPad")
                }
            }
            .actionSheet(isPresented: $showingActionSheet) {
             
                ActionSheet(
                    title: Text("Action for this topic"),
                    message: Text("Action Sheet message"),
                    buttons: [  ///two ways to provide the action,either action: func, or in {} as a closure
                        //.default(Text("Dismiss Action Sheet"), action: addTopic),
                        //.default(Text("Dismiss Action Sheet")) { addTopic()},
                        .default(Text("Display MoreSheet")) { self.showingMoreSheet = true},///seems that all buttons are called .default
                            .cancel()
                    ])
                
            }
            //.sheet(isPresented: $showingMoreSheet) { MoreSheet(topic: onMoreTopic!)}
            
           
            .sheet(item: $onMoreTopic) { item in
                //MoreSheet(topic: item)}
                //print("onMoreTopic is now \(item.name)")
                withAnimation {


                    //TopicEditView(topic: item)
                    TopicEntryView(isPresented: $showTopicEntryView, topic: item)

                    //topicStore.controllerDidChangeContent()
            }
            }
            
            .popover(isPresented: $showingPopover)  {
                Text("Popover text")
                    .font(.headline)
                    .padding()
            }
                
                
                
            .navigationBarTitle("Topics")
            //.background(Color.black) //no effect
            
            //.edgesIgnoringSafeArea(.all)
            .navigationBarItems(trailing: Button(action: {
                withAnimation {
                    print("NewTopic View called here")
                    
                    showTopicEntryView = true
                }
                
            })
            {Text(Image(systemName: "plus"))
                .padding()
                .imageScale(.large)
            })
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        } //end of NavView
            .navigationViewStyle(StackNavigationViewStyle())//also I did adjust a couple of infoplist items...
            //.background(Color.black)//no effect
            .sheet(isPresented: $showTopicEntryView)  {
                TopicEntryView(isPresented:$showTopicEntryView, topic: onMoreTopic) //not sure if this onMoreTopic will revert to nil
            }
        
            //.background(Color.black) //no effect
      //   } //end of VStack
    }//end of body
    //MARK:- addTopic
    private func addTopic() {
        withAnimation {
            let newTopic = Topic(context: viewContext)
            newTopic.topicName = self.newTopic
            //need to verify whether the topic array has the new topic added to it.
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

struct MoreSheet: View {
    var topic: Topic
    var body: some View {
        Text("The topic's name is \(topic.name)")
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
