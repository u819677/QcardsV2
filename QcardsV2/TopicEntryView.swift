//
//  TopicEntryView.swift
//  Qcards
//
//  Created by Richard Clark on 08/06/2021.
//

import SwiftUI
import CoreData


struct TopicEntryView: View {
    
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentionMode
    
    var topic: Topic? // = nil
    @State var topicName: String // = ""
    
    @State private var isEditing: Bool = false
    @Binding var isPresented: Bool

    init(isPresented: Binding<Bool>, topic: Topic?)
    {
        self._isPresented = isPresented
        self.topic = topic
        self._topicName = State(initialValue: topic?.name ?? "")    //not  //self._topicName = State(wrappedValue: "")
    }
    //MARK:- body
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
                            if !isBlank(topicName) {    ///can maybe tidy this up to deactivate Save button for the case of blank entry
                                print("topicName is not blank")
                                addTopic()
                            }
                        }
                        self.isPresented = false
                        presentionMode.wrappedValue.dismiss()
                        
                    } ){
                        Text ("Save")}
                }
                .padding(20)

                VStack {
                    Spacer()
                    Text(topic?.name  == nil ? "Enter a name for the new Topic:" : "Edit Topic name:")
                        .foregroundColor(.blue) ///could maybe tighten up the spacing between the text and the textField
                    TextField("", text: $topicName )    //no placeholder text here due it's not visible anyway.
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .frame(minWidth: 290, idealWidth: 500, maxWidth: 500, minHeight: 45, idealHeight: 45, maxHeight: 55, alignment: .center)
                        .font(.custom("Noteworthy Bold", size: 35))
                        .foregroundColor(.white)
                        .accentColor(.white)    //this is the cursor color
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 0.5))
                        .padding()
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .overlay(RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(Color.black,lineWidth: 8)
                            .shadow(color: .white, radius: 5)
                            .cornerRadius(5)
                )
            }
        }
    }
    //MARK:- addTopic
    private func addTopic() {
        withAnimation {
            let newTopic = Topic(context: viewContext)//original
            newTopic.topicName = topicName//original
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
    //MARK:- editTopic
    private func editTopic(topic:Topic) {
        topic.topicName = topicName
        print("topic name \(topic.name) is edited here")
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
func isBlank(_ string: String) -> Bool {    //convenience function to prevent saving blank entry
    for character in string {
        if !character.isWhitespace {
            return false
        }
    }
    return true
}

//struct TopicEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        TopicEntryView(isPresented: .constant(true))
//    }
//}
