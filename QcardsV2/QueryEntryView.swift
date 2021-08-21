//
//  NewQueryEntry.swift
//  Qcards
//
//  Created by Richard Clark on 30/01/2021.
//

import SwiftUI
import CoreData

struct QueryEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isPresented: Bool
    @State var textQ: String = ""
    @State var textA: String = ""
    @State var textE: String = ""
    
    var selectedTopic: Topic?
    
    
    init(isPresented: Binding<Bool>, selectedTopic: Topic) {
        UITextView.appearance().backgroundColor = .clear
        self._isPresented = isPresented
        self.selectedTopic = selectedTopic
    }
    
    var body: some View {
        ZStack {
            Image("blackboard")
                .resizable()
            VStack {
                HStack {//Cancel and Save buttons
                    Button(action: {
                        self.isPresented = false//this is the Cancel button
                    } ){
                        Text ("Cancel")}
                    //.foregroundColor(.white)
                    .padding(.leading)
                    Spacer()
                    Button(action: {
                        self.isPresented = false//this is the AddNewQuery button
                        self.addQuery()
                    } ){
                        Text ("Save ")}
                    //.foregroundColor(.white)
                    .padding(.trailing)
                }//.offset(y: 15)
                .padding(5)
                .padding(.top, 10)//seems to be more responsive than when using .offset(y:15) which has same effect
                ScrollView {
                    ScrollViewReader {value in
                        Text("Enter Question:")
                            .modifier(textMods())
                        TextEditor(text: $textQ)
                            .modifier(editorMods())
                            .lineSpacing(0)
                        Text("Enter Answer:")
                            .modifier(textMods())
                        TextEditor(text: $textA)
                            .modifier(editorMods())
                            .id(1)//seems that can just allocate a view with an id number! works well.
                            .onTapGesture {
                                withAnimation {
                                value.scrollTo(3, anchor: .bottom)//this seems to do it
                                }
                            }//to move text fields up a bit, incase small iPhone

                        Text("Enter any extra info:")
                            .modifier(textMods())
                        TextEditor(text: $textE)
                            .modifier(editorMods())
                            .id(3)
                            .lineLimit(4)
                    }
                }.padding()//.bottom)//end of ScrollView is here
                .offset(y: -35)//moves the text boxes all up towards the top to make space for keyboard
            }
            .overlay(RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color.black,lineWidth: 8)
                     .shadow(color: .white, radius: 5)
                        .cornerRadius(5)
                     )
        }
        //.border(Color.gray, width: 5)
        //.border(Color(red:0.6, green:0.4, blue:0.2, opacity: 1.0),width: 10)
        //.shadow(color: .white, radius: 5)
    }
    
    private func addQuery() {
        withAnimation {
   
            let newQuery1 = Query(context: viewContext)
            newQuery1.queryQuestion = textQ
            newQuery1.answer = textA
            newQuery1.extra = textE
            //newQuery1.topic = selectedTopic!//this works!
            selectedTopic!.addToQuery(newQuery1)//this works fine! what was I doing??
         
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
}
struct editorMods: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .frame(minWidth: 290, idealWidth: 500, maxWidth: 500, minHeight: 35, idealHeight: 43, maxHeight: 65, alignment: .bottomLeading)
            .accentColor(.white)
            .font(.custom("Noteworthy Bold", size: 23))
            .foregroundColor(.white)
            //.alignmentGuide(.bottom, computeValue: <#T##(ViewDimensions) -> CGFloat#>)
            // .alignmentGuide(.bottom) { _ in   -20 }//from hackingWS, not convinced has effect
            //.frame(minWidth: 290,  minHeight: 35)
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 1))
            //.bold()
            .lineLimit(2)
            .lineSpacing(0)
    }
}
struct textMods: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.subheadline)
            .foregroundColor(.white)
            .offset(y:10)
    }
}

//struct NewQueryEntry_Previews: PreviewProvider {
//    static var previews: some View {
//        NewQueryEntry(isPresented: .constant(true))
//    }
//}

