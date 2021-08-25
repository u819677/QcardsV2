//
//  TopicEntryView.swift
//  Qcards
//
//  Created by Richard Clark on 08/06/2021.
//
import SwiftUI

struct TopicEntryView: View {   ///This view is used for both new topic entry and for when editing an existing topic.
 
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentionMode ///allows dismissal of view when editing
    
    var topic: Topic?
    @State var newTopicName: String /// this is needed to work with a TextField, which uses a binding
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>, topic: Topic?)
    {
        self._isPresented = isPresented
        self.topic = topic
        self._newTopicName = State(initialValue: topic?.name ?? "")    //not  //self._newTopicName = State(wrappedValue: "")
    }
    //MARK:- body
    var body: some View {
        ZStack {
            Image("blackboard")
                .resizable()
            VStack {
                HStack {
                    Button(action: {
                       // self.isPresented = false
                        presentionMode.wrappedValue.dismiss()   ///need this method to dismiss the view when in edit mode, and it works for both
                    } ){
                        Text ("Cancel")}
                    Spacer()
                    Button(action: {
                        ///logic here determines whether view is editing or creating new topic
                        if  topic != nil && isSensible(newTopicName) {  //test for new Topic entry or editing an existing topic
                            editTopic(topic:topic!) ///passing in the topic being edited
                        } else {
                            if isSensible(newTopicName) {
                                addTopic()  ///creates a new topic from scratch
                            }
                        }
                       // self.isPresented = false    /// and this other method to dismiss the view when in new topic mode
                        presentionMode.wrappedValue.dismiss()
                    } ){
                        Text ("Save")}
                }
                .padding(20)
                
                VStack {
                    Spacer()
                    ///logic here displays relevant instruction depending on whether View mode is new topic entry or edit mode
                    Text(topic?.name  == nil ? "Enter a name for the new Topic:" : "Edit Topic name:")
                        .foregroundColor(.white) ///could maybe tighten up the spacing between the text and the textField
                    TextField("", text: $newTopicName )    //no placeholder text given here due it's not visible anyway.
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
                }//end of Text + TextField VStack
                .overlay(RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(Color.black,lineWidth: 8)
                            .shadow(color: .white, radius: 5)
                            .cornerRadius(5)
                )
            }//end of main  VStack
        }   //end of ZStack
    }
    //MARK:- addTopic
    private func addTopic() {
        withAnimation {
            let newTopic = Topic(context: viewContext)//original
            newTopic.topicName = newTopicName//original
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
        topic.topicName = newTopicName
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

func isSensible(_ userText: String) -> Bool {
    if userText.isEmpty || userText.count < 4  {    //maybe need to add more conditions here?
        return false
    }
    return true
}
//struct TopicEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        TopicEntryView(isPresented: .constant(true))
//    }
//}
