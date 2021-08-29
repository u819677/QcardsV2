//
//  NewQueryEntry.swift
//  Qcards
//
//  Created by Richard Clark on 30/01/2021.
//
import SwiftUI

struct QueryEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State var textQ: String = ""
    @State var textA: String = ""
    @State var textE: String = ""
    var selectedTopic: Topic?   ///this is the inbound topic, needed for new query creation
    var optionalQuery: Query?   ///this is a query for editing
    
    // this view has 2 initializers because it can be used in new query and edit query cases
    init(selectedTopic: Topic?)      {  ///this init is for the new query case
        self.selectedTopic = selectedTopic
        UITextView.appearance().backgroundColor = .clear    ///this stops the text field background being white
    }
    init(optionalQuery: Query?) {       ///this init is for the query edit case
        self.optionalQuery = optionalQuery
        self._textQ = State(initialValue: optionalQuery?.queryQuestion ?? "")
        self._textA = State(initialValue: optionalQuery?.answer ?? "")
        self._textE = State(initialValue: optionalQuery?.extra ?? "")
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        ZStack {
            Image("blackboard")
                .resizable()
            VStack {
                HStack {//Cancel and Save buttons
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    } ){
                        Text ("Cancel")}
                    //.foregroundColor(.white)
                    .padding(.leading)
                    Spacer()
                    Button(action: {
                        if isSensible(textQ){   ///this only allows the save if isSensible
                            if optionalQuery != nil {   ///this is the query edit mode
                                editQuery(query: optionalQuery)
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                self.addQuery()
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                    } ){
                        Text ("Save ")}
                    //.foregroundColor(.white)
                    .padding(.trailing)
                }//.offset(y: 15)
                .padding(5)
                .padding(.top, 10)//seems to be more responsive than when using .offset(y:15) which has same effect
                ScrollView {
                    ScrollViewReader {value in
                        Text(selectedTopic != nil ? "Enter Question:" : "Edit Question:")
                            .modifier(textMods())
                        TextEditor(text: $textQ)
                            .modifier(editorMods())
                            .lineSpacing(0)
                        Text(selectedTopic != nil ? "Enter Answer:" : "Edit Answer:")
                            .modifier(textMods())
                        TextEditor(text: $textA)
                            .modifier(editorMods())
                            .id(1)//seems that can just allocate a view with an id number! works well.
                            .onTapGesture {
                                withAnimation {
                                    value.scrollTo(3, anchor: .bottom)//this seems to do it
                                }
                            }//to move text fields up a bit, incase small iPhone
                        Text(selectedTopic != nil ? "Enter any extra info:" : "Edit extra info:")
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
    }
  //MARK:- saving query functions
    private func addQuery() {
        withAnimation {
            let newQuery1 = Query(context: viewContext)
            newQuery1.queryQuestion = textQ
            newQuery1.answer = textA
            newQuery1.extra = textE
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
    
    private func editQuery(query: Query?) {
        optionalQuery?.queryQuestion = textQ
        optionalQuery?.answer = textA
        optionalQuery?.extra = textE
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
//MARK:- editor and text mods
struct editorMods: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .frame(minWidth: 290, idealWidth: 500, maxWidth: 500, minHeight: 35, idealHeight: 43, maxHeight: 65, alignment: .bottomLeading)
            .accentColor(.white)
            .font(.custom("Noteworthy Bold", size: 23))
            .foregroundColor(.white)
            //.alignmentGuide(.bottom, computeValue: T##(ViewDimensions) -> CGFloat)
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

