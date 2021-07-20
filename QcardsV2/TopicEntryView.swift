//
//  TopicEntryView.swift
//  Qcards
//
//  Created by Richard Clark on 08/06/2021.
//

import SwiftUI
import CoreData

//extension Binding {
//    init(_ source: Binding<Value?>, _ defaultValue: Value)
//    {
//        if source.wrappedValue == nil {
//            source.wrappedValue = defaultValue
//        }
//        self.init(source)!
//    }
//
//}

struct TopicEntryView: View {
    
    
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentionMode
    @Binding var isPresented: Bool
    @State private var isEditing: Bool = false
    //@State private var topicName: String = ""
    @State var topicName: String = ""
    var topic: Topic? // = nil
    
    @State var testText: String = ""
    
    
   init(isPresented: Binding<Bool>,
        topic: Topic?) {
    self._isPresented = isPresented
    self.topic = topic
    
    self._topicName = State(wrappedValue: topic?.name ?? "nil")
    
    
    
    
    
    print("topic coming in is  \(topic?.name ?? "nil")")
    if topic != nil {
        
        testText = "topic to edit"
        print ("testText = \(testText)")
    }
        //thnk need binding var here not@State var...
    //topicName = "topic name init" //topic!.name
       //print("topicName has been given a value of \($topicName)")//state's value outside of access for a view is not good, results in constant binding of initial value and will not update
    //}
   }
    
//        if topic  != nil {
//            topicName = topic!.name
//        }

    
    var body: some View {
        
        ZStack {
            Image("blackboard")
                .resizable()
            VStack {
                HStack {
                    Button(action: {
                        print("the topic coming in is \(topic?.name ?? "nil")")
                     
                        self.isPresented = false
                        presentionMode.wrappedValue.dismiss()   ///need both these 2 methods to remove the view, due 2 methods used to show it
                    } ){
                        Text ("Cancel")}
                    Spacer()
                    Button(action: {
                        if let topic = topic {  //test for new Topic entry or editing an existing topic
                        editTopic(topic:topic)
                        } else {
                            addTopic()
                        }
                        //addTopic()
                        self.isPresented = false
                    } ){
                        Text ("Save")}
                }
                .padding(20)
                //Text(topic == nil ? "Enter New Topic Name:" : "Edit Topic name:")
                //Text("Enter new Topic Name:")
                  
               TextField("enter new Topic Name", text: $topicName)
                //TextField("enter new Topic Name", text: $topicName ?? "")
               
                //TextField(topic == nil ? "enter new Topic Name" : "don't", text:  $topicName)
                .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .frame(minWidth: 290, idealWidth: 500, maxWidth: 500, minHeight: 45, idealHeight: 45, maxHeight: 55, alignment: .center)
                    .font(.custom("Noteworthy Bold", size: 35))
                    .foregroundColor(.white)
                    .accentColor(.white)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 0.5))
                    .padding()
                Spacer()
                Spacer()
                Spacer()
            }
            .overlay(RoundedRectangle(cornerRadius: 5)
                        //.strokeBorder(Color(red:0.6, green:0.4, blue:0.2, opacity: 1.0),lineWidth: 8)
                        .strokeBorder(Color.black,lineWidth: 8) //cannot find black in scope
                        .shadow(color: .white, radius: 5)
                        .cornerRadius(5)
            )
        }
    }
    private func addTopic() {
        withAnimation {
            
            let newTopic = Topic(context: viewContext)//original
            newTopic.topicName = topicName//original
            //let newQuery = Query(context: viewContext)
            //newTopic.query? = .adding(newQuery)
            //var tempArray:[Query] = newTopic.queryArray
            //newQuery.topic?.topicName = newTopic.topicName
            
            //tempArray.append(newQuery)
            //newTopic.queryArray = tempArray
            //newTopic.addToQuery(newQuery)
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
        private func editTopic(topic:Topic) {
            
            print("topic name \(topic.name) is edited here")
            
    }
}


//struct TopicEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        TopicEntryView(isPresented: .constant(true))
//    }
//}
